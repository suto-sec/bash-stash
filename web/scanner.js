// bash stash — the scanner for code inside an imported pack (the fixture, the checker and the reference solution of a script).
// scan(text) -> [{ level: 'red' | 'warn', line, msg, snippet }]
//   red   a thing no exercise needs and a careless or hostile file could abuse: the import is refused.
//   warn  unusual: shown to the user, who can still import.
// Bash is too dynamic to be proven safe by reading it, so this is a safety net against mistakes and the obvious abuses, not a guarantee;
// the other layers are: nothing runs at import, the code is shown and must be allowed per pack, it runs in the sandbox of the checker
// (a throw-away folder, a time limit, no network) and a snapshot of the user's progress is taken first (see web/server.js).
// How it reads: heredoc bodies and comments are blanked, quoted text is blanked (except $( ) and backticks inside double quotes, which are
// code), and what is left is cut into commands. The first word of each command is checked (wrappers like timeout, env, xargs are looked
// through), plus the redirections, the paths given to commands that change things, and a few strings that are red wherever they appear.
'use strict';
const fs = require('fs');
const path = require('path');

let KNOWN = null;                 // commands the course material uses: anything else is a warning
function known() {
  if (!KNOWN) { try { KNOWN = new Set(JSON.parse(fs.readFileSync(path.join(__dirname, 'scanner-commands.json'), 'utf8'))); } catch { KNOWN = new Set(); } }
  return KNOWN;
}

const KEYWORDS = new Set(['if', 'then', 'else', 'elif', 'fi', 'for', 'while', 'until', 'do', 'done', 'case', 'esac', 'in', 'select', 'function', '!', '{', '}', '[[', ']]', 'time', 'coproc']);
const NETWORK = new Set(['curl', 'wget', 'nc', 'ncat', 'netcat', 'ssh', 'scp', 'sftp', 'ftp', 'tftp', 'telnet', 'socat', 'nmap', 'rsync', 'dig', 'nslookup', 'host', 'ping', 'ping6', 'traceroute', 'mtr', 'ip', 'ifconfig', 'iptables', 'nft', 'openssl', 'mail', 'sendmail', 'mutt', 'git', 'svn', 'pip', 'pip3', 'npm', 'npx', 'gem', 'cargo', 'go', 'apt', 'apt-get', 'aptitude', 'dpkg', 'snap', 'yum', 'dnf', 'pacman', 'apk', 'docker', 'podman', 'kubectl']);
const PRIV = new Set(['sudo', 'su', 'doas', 'pkexec', 'runuser', 'chroot', 'nsenter', 'unshare', 'setcap', 'mount', 'umount', 'modprobe', 'insmod', 'sysctl', 'reboot', 'shutdown', 'poweroff', 'halt', 'init', 'systemctl', 'service', 'crontab', 'at', 'batch', 'nohup', 'disown', 'setsid', 'screen', 'tmux', 'daemonize', 'useradd', 'userdel', 'usermod', 'groupadd', 'passwd', 'chpasswd', 'visudo', 'killall', 'pkill', 'skill']);
const INTERP = new Set(['python', 'python2', 'python3', 'perl', 'ruby', 'node', 'nodejs', 'php', 'lua', 'tclsh', 'gcc', 'cc', 'g++', 'clang', 'make', 'java', 'javac', 'rustc', 'osascript']);
const CHANGERS = new Set(['rm', 'mv', 'cp', 'chmod', 'chown', 'chgrp', 'ln', 'truncate', 'dd', 'mkdir', 'rmdir', 'touch', 'tee', 'install', 'shred', 'mkfifo', 'mknod', 'unlink', 'rename']);
const WRAPPERS = new Set(['timeout', 'env', 'nice', 'ionice', 'command', 'builtin', 'xargs', 'stdbuf', 'time', 'exec', 'sh', 'bash', 'dash', 'zsh', 'ksh']);
const SHELLS = new Set(['sh', 'bash', 'dash', 'zsh', 'ksh']);
const SAFE_ABS = /^\/(dev\/(null|stdout|stderr|stdin|zero|full|urandom|random)|proc\/self\/)/;

// ---------------------------------------------------------------- the lexer
// -> { code, rawAt } where `code` has the same line structure as the text with comments, heredoc bodies and quoted text blanked
function blank(text) {
  const out = [];
  const n = text.length;
  let i = 0, line = 1;
  const heredocs = [];                 // delimiters waiting for their body, in order: { word, tabs }
  const push = c => { out.push(c); if (c === '\n') line++; };
  // inside $( ... ) or ` ... ` found in double quotes the text is code again
  function subst(close, depthStart) {
    let depth = depthStart;
    while (i < n) {
      const c = text[i];
      if (close === '`') { if (c === '`') { push(' '); i++; return; } }
      else { if (c === '(') depth++; else if (c === ')') { depth--; if (depth === 0) { push(')'); i++; return; } } }
      if (c === "'") { push('_'); i++; while (i < n && text[i] !== "'") { push(text[i] === '\n' ? '\n' : '_'); i++; } if (i < n) { push('_'); i++; } continue; }
      if (c === '"') { push('_'); i++; dq(); continue; }
      push(c); i++;
    }
  }
  function dq() {                      // double-quoted text: blanked, except command substitutions
    while (i < n) {
      const c = text[i];
      if (c === '\\') { push('_'); i++; if (i < n) { push(text[i] === '\n' ? '\n' : '_'); i++; } continue; }
      if (c === '"') { push('_'); i++; return; }
      if (c === '$' && text[i + 1] === '(' && text[i + 2] !== '(') { push(' '); push('$'); push('('); i += 2; subst(')', 1); continue; }
      if (c === '`') { push(' '); push('`'); i++; subst('`', 0); continue; }
      push(c === '\n' ? '\n' : '_'); i++;
    }
  }
  let atLineStart = true;
  while (i < n) {
    const c = text[i];
    if (heredocs.length && atLineStart) {            // the body of a heredoc: blank it up to its delimiter line
      const h = heredocs[0];
      let j = text.indexOf('\n', i); if (j < 0) j = n;
      let ln = text.slice(i, j);
      if (h.tabs) ln = ln.replace(/^\t+/, '');
      if (ln === h.word) heredocs.shift();
      for (let k = i; k < j; k++) out.push('_');
      i = j;
      if (i < n) { push('\n'); i++; }
      atLineStart = true;
      continue;
    }
    atLineStart = false;
    if (c === '\n') { push('\n'); i++; atLineStart = true; continue; }
    if (c === '\\') { push(' '); i++; if (i < n) { push(text[i] === '\n' ? '\n' : ' '); if (text[i] === '\n') atLineStart = false; i++; } continue; }
    if (c === "'") { push('_'); i++; while (i < n && text[i] !== "'") { push(text[i] === '\n' ? '\n' : '_'); i++; } if (i < n) { push('_'); i++; } continue; }
    if (c === '"') { push('_'); i++; dq(); continue; }
    if (c === '#' && (i === 0 || /[\s;|&(]/.test(text[i - 1]))) { while (i < n && text[i] !== '\n') { out.push(' '); i++; } continue; }
    if (c === '<' && text[i + 1] === '<' && text[i + 2] !== '<') {
      const m = /^<<(-?)\s*(["']?)([A-Za-z_][\w]*)\2/.exec(text.slice(i, i + 80));
      if (m) { heredocs.push({ word: m[3], tabs: m[1] === '-' }); out.push(...' <<'); i += 2; continue; }
    }
    push(c); i++;
  }
  return out.join('');
}

// ---------------------------------------------------------------- the commands
function commandsOf(code) {
  const res = [];
  code.split('\n').forEach((ln, idx) => {
    const line = idx + 1;
    // [[ ... ]] and (( ... )) are tests and arithmetic, not commands (a $( ) inside them still is code: it is kept)
    const keep = span => (span.match(/\$\([^()]*\)|`[^`]*`/g) || []).map(x => ` ; ${x.replace(/^\$\(|\)$/g, '')} ; `).join('');
    ln = ln.replace(/\[\[.*?\]\]/g, m => ' [[ ]] ' + keep(m)).replace(/\$\(\([^]*?\)\)/g, ' _ ').replace(/\(\([^)]*\)\)/g, m => ' (( )) ' + keep(m));
    const bg = /[^&]&\s*$/.test(ln);
    const stack = [];
    let cur = '', swallow = false;               // swallow: the rest of a word that continued after a closed $( )
    const flush = () => { const words = cur.trim().split(/\s+/).filter(Boolean); if (words.length) res.push({ words, line, bg: false }); cur = ''; };
    for (let i = 0; i < ln.length; i++) {
      const c = ln[i], two = ln.substr(i, 2);
      if (swallow) { if (/[\s;|&()]/.test(c)) swallow = false; else continue; }
      if (c === '$' && ln[i + 1] === '(') { flush(); stack.push('sub'); i++; continue; }
      if (c === '`') { flush(); stack.push('tick'); continue; }           // (a backtick opens and the next one closes: approximated below)
      if (c === '(') {
        if (cur.trim().endsWith('=') || /=\s*$/.test(cur)) {                    // an array: name=( ... ): its words are data, but a $( ) inside is code
          let d = 1, j = i + 1;
          while (j < ln.length && d) { if (ln[j] === '(') d++; else if (ln[j] === ')') d--; j++; }
          const span = ln.slice(i + 1, d ? ln.length : j - 1);
          for (const m of span.matchAll(/\$\(([^()]*)\)|`([^`]*)`/g)) for (const x of commandsOf(m[1] || m[2] || '')) res.push({ ...x, line });
          i = j - 1; continue;
        }
        flush(); stack.push('grp'); continue;
      }
      if (c === ')') { const k = stack.pop(); if (k === undefined) { cur = ''; } else { flush(); if (k === 'sub') swallow = true; } continue; }
      if (c === ';' || c === '\n' || two === '&&' || two === '||' || c === '|' || (c === '&' && ln[i + 1] !== '>' && ln[i - 1] !== '>' && ln[i - 1] !== '&')) { flush(); if (two === '&&' || two === '||') i++; continue; }
      if ((c === '{' || c === '}') && (i === 0 || /\s/.test(ln[i - 1])) && (i + 1 === ln.length || /\s/.test(ln[i + 1]))) { flush(); continue; }
      cur += c;
    }
    flush();
    if (bg) res.push({ words: ['&'], line, bg: true });
  });
  return res;
}

function scan(text, nest = 0) {
  const findings = [];
  const rawLines = text.split('\n');
  const add = (level, line, msg) => {
    if (!findings.some(f => f.level === level && f.line === line && f.msg === msg)) findings.push({ level, line, msg, snippet: (rawLines[line - 1] || '').trim().slice(0, 120) });
  };
  const code = blank(text);
  const codeLines = code.split('\n');

  // red wherever they appear in the text, quoted or not (heredocs are data, so they are skipped by `code` but not here)
  rawLines.forEach((ln, idx) => {
    const l = idx + 1;
    if (/\/dev\/(tcp|udp)\//.test(ln)) add('red', l, 'opens a network connection (/dev/tcp or /dev/udp)');
    if (/\.progress|\/home\/alumno|alumno\/lab/.test(ln)) add('red', l, "refers to the lab's own files (progress, exercises, solutions or the engine)");
    if (/:\s*\(\s*\)\s*\{\s*:\s*\|\s*:/.test(ln)) add('red', l, 'looks like a fork bomb');
  });

  // variables of the engine that a fixture or a checker has no business with
  codeLines.forEach((ln, idx) => {
    const m = /\$\{?(LAB|PROGRESS|SBROOT|SB|RES|RNGF|BASH_SOURCE|BASH_ENV)\b/.exec(ln);
    if (m) add('red', idx + 1, `uses $${m[1]}, an internal variable of the lab engine`);
    if (/(^|[\s;|&(])(BASH_ENV|LD_PRELOAD|LD_LIBRARY_PATH)=/.test(ln)) add('red', idx + 1, 'changes a variable that makes programs load other code');
  });

  const defined = new Set();
  for (const m of text.matchAll(/(^|[\n;{&|(])\s*(?:function\s+)?([A-Za-z_][\w:-]*)\s*\(\s*\)/g)) defined.add(m[2]);
  for (const m of text.matchAll(/(^|\n)\s*function\s+([A-Za-z_][\w:-]*)/g)) defined.add(m[2]);

  function judge(words, line, depth = 0) {
    let ws = words.slice();
    while (ws.length && ((KEYWORDS.has(ws[0]) && !['for', 'select', 'case', 'function', 'in'].includes(ws[0])) || /^[A-Za-z_]\w*(\[[^\]]*\])?\+?=/.test(ws[0]))) {
      if (/^(LD_PRELOAD|LD_LIBRARY_PATH|BASH_ENV)=/.test(ws[0])) add('red', line, `sets ${ws[0].split('=')[0]} for a command`);
      else if (/^PATH=/.test(ws[0])) add('warn', line, 'changes PATH, which decides which programs run');
      ws.shift();
    }
    if (!ws.length) return;
    if (['for', 'select', 'case', 'function', 'in', '[[', '[', '((', '(('].includes(ws[0])) return;               // (a name follows, not a command)
    let cmd = ws[0].replace(/^\\/, '');
    if (/^\/[A-Za-z][\w.\/-]*$/.test(cmd)) {
      const base = path.basename(cmd);
      if (!SAFE_ABS.test(cmd) && !/^\/(usr\/)?(local\/)?s?bin\//.test(cmd) && !cmd.startsWith('/dev/')) add('red', line, `runs ${cmd}, a program given by its absolute path`);
      cmd = base;
    } else if (cmd.startsWith('/')) return;                                           // (a path in a list or a case pattern, not a command)
    if (cmd.startsWith('./') || cmd.startsWith('../')) return;                // the user's own script, run by the checker
    if (cmd.startsWith('$') ) { if (!/^\$\{?(\w+)\}?$/.test(cmd) || !/^\$(SCRIPT|script|1|bin|prog|cmd_)/.test(cmd)) add('warn', line, `runs ${cmd}, a command that is only known when the script runs`); return; }
    if (cmd === 'eval') { if (!/\beval\s+["']?(set --|\w+=\(|local )/.test(rawLines[line - 1] || '')) add('red', line, '`eval` of text built at run time'); return; }
    if (cmd === 'source' || cmd === '.') { add('red', line, `\`${cmd}\` loads and runs another file`); return; }
    if (cmd === 'exec') { const nxt = ws[1] || ''; if (nxt && !/^(\d*[<>]|[<>]|-)/.test(nxt)) { add('red', line, '`exec` replaces the shell with another program'); } return; }
    if (NETWORK.has(cmd)) { add('red', line, `\`${cmd}\` uses the network or installs software`); return; }
    if (PRIV.has(cmd)) { add('red', line, `\`${cmd}\` needs privileges, changes the system or leaves something running`); return; }
    if (INTERP.has(cmd)) { add('red', line, `\`${cmd}\` runs another language or compiles code`); return; }
    if (cmd === 'trap') { add('warn', line, '`trap` runs commands later, when a signal arrives'); return; }
    if (cmd === 'alias') { add('warn', line, '`alias` redefines a command'); return; }
    if (WRAPPERS.has(cmd) && depth < 6) {
      let rest = ws.slice(1);
      if (SHELLS.has(cmd) && rest.some(w => /^-[a-zA-Z]*c/.test(w))) {
        const m = /\b(?:ba|da|z|k)?sh\s+-\w*c\s+(["'])(.*?)\1/.exec(rawLines[line - 1] || '');
        if (m && depth < 3) { for (const f of scan(m[2], depth + 1)) add(f.level, line, `in the command string: ${f.msg}`); }
        else add('warn', line, `\`${cmd} -c\` runs a command string that cannot be read here`);
      }
      while (rest.length && (rest[0].startsWith('-') || /^\d+(\.\d+)?[smhd]?$/.test(rest[0]) || /^\w+=/.test(rest[0]))) rest.shift();
      if (rest.length && !SHELLS.has(cmd)) judge(rest, line, depth + 1);
      return;
    }
    if (cmd === 'find') {                                                      // find ... -exec CMD ... ;
      const i = ws.findIndex(w => /^-(exec|execdir|ok|okdir)$/.test(w));
      if (i >= 0) judge(ws.slice(i + 1), line, depth + 1);
    }
    if (CHANGERS.has(cmd)) {
      const args = ws.slice(1).filter(w => !w.startsWith('-'));
      let targets = args;                                                          // what the command changes
      if (cmd === 'cp' || cmd === 'ln' || cmd === 'install') targets = args.length > 1 ? args.slice(-1) : [];   // only the destination (a symlink may point anywhere)
      for (const w of targets) if ((w === '/' || /^\/[A-Za-z*]/.test(w)) && !SAFE_ABS.test(w)) { add('red', line, `\`${cmd}\` changes ${w.replace(/_+/g, '…')}, outside the sandbox`); break; }
    }
    if (cmd === 'awk' || cmd === 'gawk' || cmd === 'mawk') { if (/system\s*\(/.test(rawLines[line - 1] || '')) add('warn', line, 'awk runs a command with system()'); }
    if (!known().has(cmd) && !defined.has(cmd) && !/^[\[\]{}!:()]+$/.test(cmd) && !/^_+$/.test(cmd) && !/^[^A-Za-z]/.test(cmd) && !/[=\/]/.test(cmd) && known().size) add('warn', line, `uses \`${cmd}\`, a command the course material does not use`);
  }

  commandsOf(code).forEach(c => {
    if (c.bg) { add('warn', c.line, 'starts a background job'); return; }
    judge(c.words, c.line);
  });

  // redirections to absolute places
  codeLines.forEach((ln, idx) => {
    for (const m of ln.matchAll(/(?:^|[^<>&\d])(\d?>>?|&>>?|>\|)\s*([^\s;|&()<>]+)/g)) {
      const tgt = m[2];
      if (tgt.startsWith('/') && !SAFE_ABS.test(tgt)) add('red', idx + 1, `writes to ${tgt.replace(/_+/g, '…')}, outside the sandbox`);
      if (/^(~\/|\$\{?(LAB|PROGRESS))/.test(tgt) && !/^~\/?$/.test(tgt)) add('warn', idx + 1, `writes to ${tgt}`);
    }
    if (/\|\s*(sudo\s+)?(ba|da|z|k)?sh\b(?!\w)/.test(ln)) add('red', idx + 1, 'pipes text into a shell');
  });
  return findings.sort((a, b) => a.line - b.line || (a.level === 'red' ? -1 : 1));
}

// the command words a text uses (for tools/gen_scanner_commands.js, which builds scanner-commands.json from the course material)
function commandWords(text) {
  const out = [];
  for (const c of commandsOf(blank(text))) {
    let ws = c.words.slice();
    for (let depth = 0; depth < 6 && ws.length; depth++) {
      while (ws.length && (KEYWORDS.has(ws[0]) || /^[A-Za-z_]\w*(\[[^\]]*\])?\+?=/.test(ws[0]))) ws.shift();
      if (!ws.length) break;
      const cmd = path.basename(ws[0].replace(/^\\/, ''));
      if (!/^[A-Za-z][\w.+-]*$/.test(cmd)) break;
      out.push(cmd);
      if (!WRAPPERS.has(cmd) || SHELLS.has(cmd)) break;
      ws = ws.slice(1);
      while (ws.length && (ws[0].startsWith('-') || /^\d+(\.\d+)?[smhd]?$/.test(ws[0]) || /^\w+=/.test(ws[0]))) ws.shift();
    }
  }
  return out;
}

module.exports = { scan, blank, commandWords };
