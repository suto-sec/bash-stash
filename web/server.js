// bash stash web UI server (runs inside the lab container as alumno).
//   /                 single page app (web/public)
//   /api/...          exercises, checker, solutions, theme
//   /pty              websocket: a real bash terminal (node-pty)
//   /vscode/...       reverse proxy to code-server (VS Code in the browser)
'use strict';
const http = require('http');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');
const { WebSocketServer } = require('ws');
const pty = require('node-pty');
const httpProxy = require('http-proxy');

const LAB = process.env.LAB || '/home/alumno/lab';
const PORT = Number(process.env.PORT || 8080);
const CODE_SERVER = 'http://127.0.0.1:8081';
const VENDOR = process.env.VENDOR || '/opt/web/node_modules';
const PUBLIC = path.join(__dirname, 'public');
const PROGRESS = path.join(LAB, '.progress');
const CS_SETTINGS = path.join(process.env.HOME || '/home/alumno', '.local/share/code-server/User/settings.json');

// ------------------------------------------------------------------ exercises
function isAttempted(file) {
  try {
    return fs.readFileSync(file, 'utf8').split('\n').some(l => !/^\s*(#.*)?$/.test(l));
  } catch { return false; }
}

function exerciseInfo(topicDir, name) {
  const dir = path.join(topicDir, name);
  const id = name.split('_')[0];
  const readme = fs.readFileSync(path.join(dir, 'README.md'), 'utf8');
  const lines = readme.split('\n');
  const title = lines[0].replace(/^#\s*\S+\s*·\s*/, '');
  const meta = lines.find(l => l.startsWith('**Topic:**')) || '';
  const level = (meta.match(/★/g) || []).length;
  const cmds = (meta.match(/\*\*Commands:\*\*\s*(.*)$/) || [, ''])[1];
  const quiz = fs.existsSync(path.join(dir, 'answer.txt'));
  const answer = path.join(dir, quiz ? 'answer.txt' : 'answer.sh');
  let status = 'new';
  if (fs.existsSync(path.join(PROGRESS, id))) status = 'pass';
  else if (fs.existsSync(path.join(PROGRESS, id + '.viewed'))) status = 'viewed';
  else if (isAttempted(answer)) status = 'attempted';
  return { id, name, title, level, cmds, quiz, dir, answer, status };
}

function index() {
  const root = path.join(LAB, 'exercises');
  return fs.readdirSync(root).filter(t => /^\d\d_/.test(t)).sort().map(t => {
    const topicDir = path.join(root, t);
    const exercises = fs.readdirSync(topicDir).filter(e => /^\d{4}_/.test(e)).sort()
      .map(e => exerciseInfo(topicDir, e));
    const first = fs.readFileSync(path.join(topicDir, exercises[0].name, 'README.md'), 'utf8');
    const title = (first.match(/\*\*Topic:\*\*\s*(.*?)\s*·/) || [, t])[1];
    return { id: t.slice(0, 2), dir: t, title, exercises };
  });
}

function findExercise(id) {
  if (!/^\d{4}$/.test(id)) return null;
  for (const t of index()) for (const e of t.exercises) if (e.id === id) return { ...e, topic: t };
  return null;
}

function solutionFile(ex) {
  const base = path.join(LAB, 'solutions', ex.topic.dir, ex.name);
  return fs.existsSync(base + '.sh') ? base + '.sh' : base + '.txt';
}

// ------------------------------------------------------------------ http helpers
function send(res, code, body, type = 'application/json') {
  res.writeHead(code, { 'Content-Type': type, 'Cache-Control': 'no-store' });
  res.end(type === 'application/json' ? JSON.stringify(body) : body);
}

const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.svg': 'image/svg+xml',
               '.map': 'application/json', '.woff2': 'font/woff2' };
function serveFile(res, file) {
  fs.readFile(file, (err, data) => {
    if (err) return send(res, 404, 'not found', 'text/plain');
    res.writeHead(200, { 'Content-Type': MIME[path.extname(file)] || 'application/octet-stream' });
    res.end(data);
  });
}

// the only third-party files the page loads (served locally: works offline)
const VENDOR_FILES = {
  'xterm.js': '@xterm/xterm/lib/xterm.js',
  'xterm.css': '@xterm/xterm/css/xterm.css',
  'addon-fit.js': '@xterm/addon-fit/lib/addon-fit.js',
  'marked.js': 'marked/marked.min.js',
};

function readBody(req) {
  return new Promise(resolve => {
    let b = '';
    req.on('data', c => { b += c; if (b.length > 1e5) req.destroy(); });
    req.on('end', () => { try { resolve(JSON.parse(b || '{}')); } catch { resolve({}); } });
  });
}

function setVSCodeTheme(theme) {
  let s = {};
  try { s = JSON.parse(fs.readFileSync(CS_SETTINGS, 'utf8')); } catch { /* fresh file */ }
  s['workbench.colorTheme'] = theme === 'light' ? 'Default Light Modern' : 'Default Dark Modern';
  fs.mkdirSync(path.dirname(CS_SETTINGS), { recursive: true });
  fs.writeFileSync(CS_SETTINGS, JSON.stringify(s, null, 2));
}

// ------------------------------------------------------------------ security
// The terminal is a real shell, so only pages served from this very server may use it:
// - Host must be localhost/127.0.0.1 (defeats DNS rebinding)
// - Origin, when present (browsers always send it for websockets and cross-site POSTs),
//   must be the same host (defeats other websites talking to localhost)
const LOCAL_HOST = /^(localhost|127\.0\.0\.1|\[::1\])(:\d+)?$/;
function trusted(req) {
  const host = req.headers.host || '';
  if (!LOCAL_HOST.test(host)) return false;
  const origin = req.headers.origin;
  if (!origin) return true;
  try { return new URL(origin).host === host; } catch { return false; }
}

// ------------------------------------------------------------------ routes
async function api(req, res, url) {
  const parts = url.pathname.split('/').filter(Boolean); // ['api', ...]
  if (parts[1] === 'ping') return send(res, 200, { ok: true });

  if (parts[1] === 'index' && req.method === 'GET') {
    return send(res, 200, index().map(t => ({
      ...t, exercises: t.exercises.map(({ dir, answer, ...e }) => e),
    })));
  }

  const ex = parts[2] ? findExercise(parts[2]) : null;
  if (['exercise', 'check', 'solution'].includes(parts[1]) && !ex) return send(res, 404, { error: 'no such exercise' });

  if (parts[1] === 'exercise' && req.method === 'GET') {
    const readme = fs.readFileSync(path.join(ex.dir, 'README.md'), 'utf8');
    return send(res, 200, { id: ex.id, title: ex.title, level: ex.level, cmds: ex.cmds, quiz: ex.quiz,
      status: ex.status, readme, dir: ex.dir, answer: ex.answer, topic: ex.topic.title });
  }

  if (parts[1] === 'check' && req.method === 'POST') {
    // stream the real checker's output (with ANSI colours) as it runs
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8', 'Cache-Control': 'no-store',
                         'X-Content-Type-Options': 'nosniff' });
    const p = spawn(path.join(LAB, 'bin/check'), [ex.id], { cwd: LAB, env: { ...process.env, LAB_COLOR: '1' } });
    p.stdout.on('data', d => res.write(d));
    p.stderr.on('data', d => res.write(d));
    p.on('close', code => res.end(`\n\x1b[2m[exit ${code}]\x1b[0m\n`));
    res.on('close', () => { if (p.exitCode === null) p.kill(); }); // browser went away
    return;
  }

  if (parts[1] === 'solution' && req.method === 'POST') {
    const body = await readBody(req);
    if (ex.status !== 'pass') {
      if (!body.confirm) return send(res, 409, { error: 'confirm required' });
      fs.mkdirSync(PROGRESS, { recursive: true });
      fs.writeFileSync(path.join(PROGRESS, ex.id + '.viewed'), 'viewed\n');
    }
    const file = solutionFile(ex);
    return send(res, 200, { file: path.relative(LAB, file), content: fs.readFileSync(file, 'utf8') });
  }

  if (parts[1] === 'theme' && req.method === 'POST') {
    const body = await readBody(req);
    try { setVSCodeTheme(body.theme); } catch (e) { return send(res, 500, { error: String(e) }); }
    return send(res, 200, { ok: true });
  }

  return send(res, 404, { error: 'unknown endpoint' });
}

const proxy = httpProxy.createProxyServer({ target: CODE_SERVER, ws: true, changeOrigin: false });
proxy.on('error', (err, req, res) => {
  if (res && res.writeHead && !res.headersSent) {
    send(res, 502, 'VS Code (code-server) is starting or not available. Reload in a few seconds.', 'text/plain');
  } else if (res && res.destroy) res.destroy();
});

function stripVscodePrefix(req) {
  req.url = req.url.replace(/^\/vscode/, '') || '/';
}

const server = http.createServer((req, res) => {
  if (!trusted(req)) return send(res, 403, 'forbidden: open bash stash at http://localhost:' + PORT, 'text/plain');
  const url = new URL(req.url, 'http://localhost');
  if (url.pathname === '/vscode') { res.writeHead(302, { Location: '/vscode/' }); return res.end(); }
  if (url.pathname.startsWith('/vscode/')) { stripVscodePrefix(req); return proxy.web(req, res); }
  if (url.pathname.startsWith('/api/')) {
    return api(req, res, url).catch(e => send(res, 500, { error: String(e) }));
  }
  if (url.pathname.startsWith('/vendor/')) {
    const f = VENDOR_FILES[url.pathname.slice('/vendor/'.length)];
    return f ? serveFile(res, path.join(VENDOR, f)) : send(res, 404, 'not found', 'text/plain');
  }
  const rel = url.pathname === '/' ? 'index.html' : url.pathname.slice(1);
  const file = path.normalize(path.join(PUBLIC, rel));
  if (!file.startsWith(PUBLIC + path.sep)) return send(res, 403, 'forbidden', 'text/plain');
  return serveFile(res, file);
});

// ------------------------------------------------------------------ terminal (websocket)
const wss = new WebSocketServer({ noServer: true });
wss.on('connection', (ws, req) => {
  const url = new URL(req.url, 'http://localhost');
  const ex = url.searchParams.get('ex') ? findExercise(url.searchParams.get('ex')) : null;
  const term = pty.spawn('bash', ['-l'], {
    name: 'xterm-256color',
    cols: Number(url.searchParams.get('cols')) || 80,
    rows: Number(url.searchParams.get('rows')) || 24,
    cwd: ex ? ex.dir : LAB,
    env: { ...process.env, TERM: 'xterm-256color', LAB_QUIET: '' },
  });
  term.onData(d => { if (ws.readyState === ws.OPEN) ws.send(d); });
  term.onExit(() => ws.close());
  ws.on('message', raw => {
    let m; try { m = JSON.parse(raw); } catch { return; }
    if (m.t === 'i' && typeof m.d === 'string') term.write(m.d);
    else if (m.t === 'r' && m.c > 0 && m.r > 0) term.resize(Math.min(m.c, 500), Math.min(m.r, 200));
  });
  ws.on('close', () => { try { term.kill(); } catch { /* already gone */ } });
});

server.on('upgrade', (req, socket, head) => {
  if (!trusted(req)) return socket.destroy();
  if (req.url.startsWith('/pty')) {
    wss.handleUpgrade(req, socket, head, ws => wss.emit('connection', ws, req));
  } else if (req.url.startsWith('/vscode/')) {
    stripVscodePrefix(req);
    proxy.ws(req, socket, head);
  } else socket.destroy();
});

server.listen(PORT, '0.0.0.0', () => console.log(`bash stash web UI on :${PORT}`));
