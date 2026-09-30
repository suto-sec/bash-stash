// bash stash web UI server (runs inside the lab container as alumno).
//   /                 single page app (web/public)
//   /api/...          exercises, checker, solutions, theme
//   /pty              websocket: a real bash terminal (node-pty)
//   /vscode/...       reverse proxy to code-server (VS Code in the browser)
'use strict';
const http = require('http');
const fs = require('fs');
const path = require('path');
const { spawn, execFileSync } = require('child_process');
const { WebSocketServer } = require('ws');
const pty = require('node-pty');
const httpProxy = require('http-proxy');
const zlib = require('zlib');

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

// Track tiers: which of the three authoring batches (tools/src/*.txt) an exercise came from —
// the base file (tier 1, closest to the course material's own examples), its "_exam" companion
// (tier 2, added specifically to mirror real exam patterns) or its "_more" companion (tier 3, the
// later bulk-expansion batch, furthest from the original teaching set). A base file's own name can
// itself end in "_exam" or "_more" (e.g. topic 18 is named "18_exam"), so a file only counts as a
// companion batch when a base file also exists under its name with that suffix stripped.
// tracks: minimal = tier 1, intermediate = tiers 1-2, complete = every tier (unfiltered = 'full').
function buildTierMap() {
  const dir = path.join(LAB, 'tools/src');
  const map = {};
  let files;
  try { files = fs.readdirSync(dir).filter(f => f.endsWith('.txt')); } catch { return map; }
  const fileSet = new Set(files);
  for (const f of files) {
    let tier = 1;
    // a file only counts as an "_exam"/"_more" companion batch when a DIFFERENT file exists under
    // its name with that suffix stripped — otherwise it's a base file whose own name happens to end
    // that way (e.g. topic 18 is named "18_exam", so "18_exam.txt" is ITS base file, and
    // "18_exam_more.txt" is correctly its "more" companion, not "18"'s).
    if (f.endsWith('_exam.txt')) {
      const base = f.slice(0, -9) + '.txt';
      if (base !== f && fileSet.has(base)) tier = 2;
    } else if (f.endsWith('_more.txt')) {
      const base = f.slice(0, -9) + '.txt';
      if (base !== f && fileSet.has(base)) tier = 3;
    } else if (f.endsWith('_intro.txt')) {
      // tier 0: tiny one-concept "Introduction" refreshers, reachable only via the per-category
      // picker on the home page — never part of any track (Minimal/Intermediate/Full all skip them)
      const base = f.slice(0, -10) + '.txt';
      if (base !== f && fileSet.has(base)) tier = 0;
    }
    const content = fs.readFileSync(path.join(dir, f), 'utf8');
    for (const m of content.matchAll(/^@@ex (\d{4})\b/gm)) map[m[1]] = tier;
  }
  return map;
}
const TIER_MAP = buildTierMap();

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
  const tier = id in TIER_MAP ? TIER_MAP[id] : 1; // tier can legitimately be 0 — `||` would misfire on it
  let status = 'new';
  if (fs.existsSync(path.join(PROGRESS, id))) status = 'pass';
  else if (fs.existsSync(path.join(PROGRESS, id + '.viewed'))) status = 'viewed';
  else if (isAttempted(answer)) status = 'attempted';
  return { id, name, title, level, cmds, quiz, dir, answer, status, tier };
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

// ------------------------------------------------------------------ theory quizzes
// Collections are compiled from tools/theory/*.txt into theory/<id>.json (tools/build_theory.js).
// They are a parallel track to the exercises: graded in the browser (instant feedback), only the
// per-question result is stored here: .progress/theory/<collection>.json  {qid: {pass, tries}}.
// Translations live in theory/<lang>/<id>.json with the same question ids, so progress is shared
// across languages; a collection without a translation falls back to English.
const THEORY = path.join(LAB, 'theory');
const THEORY_PROGRESS = path.join(PROGRESS, 'theory');
const SAFE_ID = /^[\w-]+$/;

const THEORY_LANGS = ['es'];
function loadCollection(id, lang) {
  if (!SAFE_ID.test(id)) return null;
  const dirs = THEORY_LANGS.includes(lang) ? [path.join(THEORY, lang), THEORY] : [THEORY];
  for (const d of dirs) {
    try { return JSON.parse(fs.readFileSync(path.join(d, id + '.json'), 'utf8')); } catch { /* try the next */ }
  }
  return null;
}
function theoryProgress(cid) {
  try { return JSON.parse(fs.readFileSync(path.join(THEORY_PROGRESS, cid + '.json'), 'utf8')); } catch { return {}; }
}
function questionStatus(p) { return !p ? 'new' : p.pass ? 'pass' : 'attempted'; }
function theoryIndex(lang) {
  let files = [];
  try { files = fs.readdirSync(THEORY).filter(f => f.endsWith('.json')).sort(); } catch { /* no theory yet */ }
  return files.map(f => loadCollection(f.slice(0, -5), lang)).filter(Boolean).map(c => {
    const prog = theoryProgress(c.id);
    return { id: c.id, title: c.title, about: c.about, groups: c.groups.map(g => ({
      id: g.id, title: g.title,
      questions: g.questions.map(q => ({ id: q.id, title: q.title, type: q.type, status: questionStatus(prog[q.id]) })),
    })) };
  });
}
function writeTheoryProgress(cid, prog) {
  fs.mkdirSync(THEORY_PROGRESS, { recursive: true });
  const file = path.join(THEORY_PROGRESS, cid + '.json');
  fs.writeFileSync(file + '.tmp', JSON.stringify(prog));
  fs.renameSync(file + '.tmp', file);
}

// ------------------------------------------------------------------ practice fixture ("play")
// exercises/<id>/ only holds README.md, check.sh and answer.sh — the actual files a script
// needs to read (created by the checker's setup()) live nowhere on disk until built. So that a
// terminal or VS Code opened on an exercise has something real to test against, we build that
// fixture once per exercise (via `bin/play`, which also symlinks answer.sh — and, when the
// checker installs it under another name, that name too — plus README.md into it) and route the
// terminal/editor there instead of the bare exercise folder. Never rebuilt on a plain open, only
// on an explicit reset, so it doesn't clobber files the learner is experimenting with.
function playDirFor(id) { return path.join(process.env.HOME || '/home/alumno', 'play', id, 'work'); }
function buildPlay(id) {
  execFileSync(path.join(LAB, 'bin/play'), [id], { cwd: LAB, stdio: 'ignore' });
}
function ensurePlay(ex) {
  if (ex.quiz) return null; // nothing to run for a quiz
  const dir = playDirFor(ex.id);
  if (!fs.existsSync(dir)) { try { buildPlay(ex.id); } catch { /* leave dir missing, caller cds to LAB */ } }
  return fs.existsSync(dir) ? dir : null;
}

// ------------------------------------------------------------------ multiple answer attempts
// Alongside the canonical answer.sh/.txt (attempt "1", implicitly), an exercise directory may hold
// extra attempts named answer2.sh, answer3.sh, ... — for keeping a previous solve around, or trying
// a different approach, without losing the one that's already passing. They're plain files living
// next to answer.sh; the checker (lib/engine.sh: check_one) already accepts a custom answer-file
// path and, when given one, deliberately skips updating the exercise's pass/fail progress — so
// checking an attempt never disturbs the exercise's official status.
function attemptExt(ex) { return ex.quiz ? '.txt' : '.sh'; }
function attemptRegex(ex) { return new RegExp(`^answer(\\d+)${attemptExt(ex) === '.sh' ? '\\.sh' : '\\.txt'}$`); }
function isValidAttemptFile(ex, name) {
  if (!name || name === path.basename(ex.answer)) return false; // that's the canonical file, no override needed
  return attemptRegex(ex).test(name) && fs.existsSync(path.join(ex.dir, name));
}
function createAttempt(ex, fromName) {
  const ext = attemptExt(ex), re = attemptRegex(ex);
  let maxN = 1; // answer.sh/.txt is implicitly attempt 1
  for (const f of fs.readdirSync(ex.dir)) {
    const m = f.match(re);
    if (m) maxN = Math.max(maxN, parseInt(m[1], 10));
  }
  const name = `answer${maxN + 1}${ext}`;
  const dest = path.join(ex.dir, name);
  const src = isValidAttemptFile(ex, fromName) ? path.join(ex.dir, fromName) : ex.answer;
  fs.copyFileSync(src, dest);
  fs.chmodSync(dest, 0o755);
  let openPath = dest;
  const playDir = ensurePlay(ex);
  if (playDir) {
    const link = path.join(playDir, name);
    try { fs.unlinkSync(link); } catch { /* didn't exist yet */ }
    fs.symlinkSync(dest, link);
    openPath = link;
  }
  return { name, path: dest, openPath };
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

  if (parts[1] === 'theory') {
    const lang = url.searchParams.get('lang');
    if (req.method === 'GET' && !parts[2]) return send(res, 200, theoryIndex(lang));
    const col = parts[2] ? loadCollection(parts[2], lang) : null;
    if (!col) return send(res, 404, { error: 'no such collection' });
    if (req.method === 'GET' && !parts[3]) return send(res, 200, col);
    if (req.method === 'POST' && parts[3] === 'reset') {
      try { fs.unlinkSync(path.join(THEORY_PROGRESS, col.id + '.json')); } catch { /* nothing stored */ }
      return send(res, 200, { ok: true });
    }
    if (req.method === 'POST' && parts[3] && SAFE_ID.test(parts[3])) {
      const known = col.groups.some(g => g.questions.some(q => q.id === parts[3]));
      if (!known) return send(res, 404, { error: 'no such question' });
      const body = await readBody(req);
      const prog = theoryProgress(col.id);
      const cur = prog[parts[3]] || { pass: false, tries: 0 };
      cur.tries += 1;
      if (body.ok === true) cur.pass = true; // once passed, it stays passed
      prog[parts[3]] = cur;
      writeTheoryProgress(col.id, prog);
      return send(res, 200, { status: questionStatus(cur) });
    }
    return send(res, 404, { error: 'unknown endpoint' });
  }

  const ex = parts[2] ? findExercise(parts[2]) : null;
  if (['exercise', 'check', 'solution', 'reset', 'attempt'].includes(parts[1]) && !ex) return send(res, 404, { error: 'no such exercise' });

  if (parts[1] === 'exercise' && req.method === 'GET') {
    const readme = fs.readFileSync(path.join(ex.dir, 'README.md'), 'utf8');
    const playDir = ensurePlay(ex);
    return send(res, 200, { id: ex.id, title: ex.title, level: ex.level, cmds: ex.cmds, quiz: ex.quiz,
      status: ex.status, readme, dir: ex.dir, answer: ex.answer, topic: ex.topic.title, playDir });
  }

  if (parts[1] === 'reset' && req.method === 'POST') {
    if (ex.quiz) return send(res, 400, { error: 'nothing to reset for a quiz' });
    try { buildPlay(ex.id); } catch (e) { return send(res, 500, { error: String(e) }); }
    return send(res, 200, { playDir: playDirFor(ex.id) });
  }

  if (parts[1] === 'attempt' && req.method === 'POST') {
    const body = await readBody(req);
    try { return send(res, 200, createAttempt(ex, body.from)); }
    catch (e) { return send(res, 500, { error: String(e) }); }
  }

  if (parts[1] === 'check' && req.method === 'POST') {
    // an explicit ?file=answerN.sh checks that attempt instead of the canonical answer.sh/.txt —
    // isValidAttemptFile rejects anything else (wrong exercise, made-up name, canonical file itself)
    const fileArg = url.searchParams.get('file');
    const args = [ex.id];
    if (isValidAttemptFile(ex, fileArg)) args.push(path.join(ex.dir, fileArg));
    // stream the real checker's output (with ANSI colours) as it runs
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8', 'Cache-Control': 'no-store',
                         'X-Content-Type-Options': 'nosniff' });
    const p = spawn(path.join(LAB, 'bin/check'), args, { cwd: LAB, env: { ...process.env, LAB_COLOR: '1' } });
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

// code-server has no settings for "start with the file-explorer sidebar closed" or "start with the
// integrated terminal open" (both are UI/session state, not settings), so a tiny script is injected
// into its HTML that does both once, right after the workbench renders:
//  - sidebar: a real click on the already-active explorer icon (what closing it by hand does) —
//    far more reliable than a keybinding for this one, since it's a plain DOM click.
//  - terminal: a synthetic Ctrl+` keydown (VS Code's own default "toggle terminal" shortcut) —
//    unlike the sidebar there is no single icon to click for "open, at whatever the default height
//    is", so the keybinding is dispatched instead; VS Code's keybinding service does not require a
//    trusted event for this one, confirmed empirically.
// It also reports the currently focused editor tab's filename to the parent page (postMessage),
// polled from the tab bar's DOM (`.tab.active[data-resource-name]`) since code-server exposes no
// API for this — the parent uses it to let "Check" run against whichever answer*.sh is focused,
// instead of only the canonical answer.sh.
const WORKBENCH_TWEAKS = nonce => `<script nonce="${nonce}">(function(){
  var tries = 0, closedSidebar = false, openedTerminal = false;
  var t = setInterval(function() {
    if (++tries > 600 || (closedSidebar && openedTerminal)) return clearInterval(t); // ~2 minutes max
    if (!closedSidebar) {
      var sidebar = document.querySelector('.part.sidebar');
      if (sidebar && sidebar.offsetWidth > 0) {
        var icon = document.querySelector('.activitybar .action-item.checked, .activitybar .action-item.active');
        if (icon) { icon.click(); closedSidebar = true; }
      }
    }
    if (!openedTerminal) {
      var panel = document.querySelector('.part.panel');
      if (panel && panel.offsetHeight > 0) { openedTerminal = true; } // confirmed open, stop retrying
      else if (document.querySelector('.monaco-workbench')) {
        var ev = { key: '\`', code: 'Backquote', keyCode: 192, which: 192, ctrlKey: true, bubbles: true, cancelable: true, composed: true };
        var kd = new KeyboardEvent('keydown', ev);
        document.dispatchEvent(kd); window.dispatchEvent(kd);
        if (document.activeElement) document.activeElement.dispatchEvent(kd);
      }
    }
  }, 200);
  var lastActive = null;
  setInterval(function() {
    var tab = document.querySelector('.tabs-container .tab.active');
    var name = tab ? tab.getAttribute('data-resource-name') : null;
    if (name !== lastActive) {
      lastActive = name;
      try { window.parent.postMessage({ source: 'bash-stash-vscode', activeFile: name }, window.location.origin); } catch (e) {}
    }
  }, 500);
})();</script>`;

const proxy = httpProxy.createProxyServer({ target: CODE_SERVER, ws: true, changeOrigin: false, selfHandleResponse: true });
proxy.on('error', (err, req, res) => {
  if (res && res.writeHead && !res.headersSent) {
    send(res, 502, 'VS Code (code-server) is starting or not available. Reload in a few seconds.', 'text/plain');
  } else if (res && res.destroy) res.destroy();
});
proxy.on('proxyRes', (proxyRes, req, res) => {
  const ct = proxyRes.headers['content-type'] || '';
  if (!ct.includes('text/html')) { res.writeHead(proxyRes.statusCode, proxyRes.headers); return proxyRes.pipe(res); }
  const chunks = [];
  proxyRes.on('data', c => chunks.push(c));
  proxyRes.on('end', () => {
    const raw = Buffer.concat(chunks);
    const enc = proxyRes.headers['content-encoding'];
    const decompress = enc === 'gzip' ? zlib.gunzipSync : enc === 'br' ? zlib.brotliDecompressSync
      : enc === 'deflate' ? zlib.inflateSync : null;
    let body;
    try { body = decompress ? decompress(raw) : raw; } catch { body = raw; }
    const htmlStr = body.toString('utf8');
    // code-server's CSP only allows inline scripts carrying its own per-response nonce
    const nonceMatch = htmlStr.match(/<script nonce="([^"]+)"/);
    const html = nonceMatch ? htmlStr.replace('</body>', WORKBENCH_TWEAKS(nonceMatch[1]) + '</body>') : htmlStr;
    const out = Buffer.from(html, 'utf8');
    const headers = { ...proxyRes.headers, 'content-length': out.length };
    delete headers['content-encoding'];
    res.writeHead(proxyRes.statusCode, headers);
    res.end(out);
  });
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
    cwd: ex ? (ensurePlay(ex) || ex.dir) : LAB,
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
