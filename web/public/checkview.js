// The result box of a Check: streams the checker's text, and when the server also sends its report of the
// failing cases (server.js: streamCheck, lib/engine.sh: report_case) shows each failure as what was run,
// plain-language hints, and expected vs yours side by side with a character-level diff.
// Without a report (quizzes, setup errors, an older server) the checker's text is shown as it always was.
const CheckView = (() => {
  const SEP = '\x1e';
  const TRAILER = /\n?\x1b\[2m\[exit \d+\]\x1b\[0m\s*$/;
  const NONL = '\u0001';                         // marks "this last line has no newline after it"
  const MAX_ROWS = 70, CONTEXT = 2;

  // ---------------------------------------------------------------- stream
  function split(raw) {                          // streamed text -> { text, report }
    const m = raw.lastIndexOf('\n' + SEP), i = m < 0 ? -1 : m + 1;
    if (i < 0) return { text: raw, report: null };
    const end = raw.indexOf('\n', i);
    if (end < 0) return { text: raw.slice(0, i), report: null };   // marker still arriving
    try { return { text: raw.slice(0, i) + raw.slice(end + 1), report: JSON.parse(raw.slice(i + 1, end)) }; }
    catch { return { text: raw, report: null }; }                    // not ours: it is just text
  }
  async function run(url, body) {                // POST, show the text as it arrives -> { text, report, code }
    let raw = '';
    try {
      const r = await fetch(url, { method: 'POST' });
      if (!r.ok) {
        const j = await r.json().catch(() => ({}));
        return { text: `${j.error || 'error ' + r.status}\n`, report: null, code: '1' };
      }
      const reader = r.body.getReader(), dec = new TextDecoder();
      for (;;) {
        const { value, done } = await reader.read();
        if (done) break;
        raw += dec.decode(value, { stream: true });
        body.innerHTML = ansiToHtml(split(raw).text);
      }
    } catch (e) { raw += `\n${e}`; }
    const { text, report } = split(raw);
    const code = ([...text.matchAll(/\[exit (\d+)\]/g)].pop() || [])[1];
    return { text, report, code };
  }

  // ---------------------------------------------------------------- diff
  function toLines(s) {                          // "a\nb\n" -> [a, b]; no final newline -> last line gets NONL
    if (s === '') return [];
    const nl = s.endsWith('\n'), a = (nl ? s.slice(0, -1) : s).split('\n');
    if (!nl) a[a.length - 1] += NONL;
    return a;
  }
  function lcsOps(a, b) {                        // [{t:'=',a,b} | {t:'-',a} | {t:'+',b}]
    let lo = 0;
    while (lo < a.length && lo < b.length && a[lo] === b[lo]) lo++;
    let ha = a.length, hb = b.length;
    while (ha > lo && hb > lo && a[ha - 1] === b[hb - 1]) { ha--; hb--; }
    const ops = [];
    for (let i = 0; i < lo; i++) ops.push({ t: '=', a: a[i], b: b[i] });
    const A = a.slice(lo, ha), B = b.slice(lo, hb), n = A.length, m = B.length;
    if (n * m > 160000) {                        // too big for the table: show the middle as one replaced block
      A.forEach(x => ops.push({ t: '-', a: x })); B.forEach(x => ops.push({ t: '+', b: x }));
    } else {
      const L = Array.from({ length: n + 1 }, () => new Uint16Array(m + 1));
      for (let i = n - 1; i >= 0; i--) for (let j = m - 1; j >= 0; j--)
        L[i][j] = A[i] === B[j] ? L[i + 1][j + 1] + 1 : Math.max(L[i + 1][j], L[i][j + 1]);
      let i = 0, j = 0;
      while (i < n && j < m) {
        if (A[i] === B[j]) { ops.push({ t: '=', a: A[i], b: B[j] }); i++; j++; }
        else if (L[i + 1][j] >= L[i][j + 1]) ops.push({ t: '-', a: A[i++] });
        else ops.push({ t: '+', b: B[j++] });
      }
      while (i < n) ops.push({ t: '-', a: A[i++] });
      while (j < m) ops.push({ t: '+', b: B[j++] });
    }
    for (let i = ha; i < a.length; i++) ops.push({ t: '=', a: a[i], b: b[i - ha + hb] });
    return ops;
  }
  function charSegs(x, y) {                      // -> [segments of x, segments of y]; a segment is [changed?, text]
    let lo = 0;
    while (lo < x.length && lo < y.length && x[lo] === y[lo]) lo++;
    let hx = x.length, hy = y.length;
    while (hx > lo && hy > lo && x[hx - 1] === y[hy - 1]) { hx--; hy--; }
    const X = [...x.slice(lo, hx)], Y = [...y.slice(lo, hy)], n = X.length, m = Y.length;
    const sx = [[0, x.slice(0, lo)]], sy = [[0, y.slice(0, lo)]];
    if (n * m > 40000) { sx.push([1, X.join('')]); sy.push([1, Y.join('')]); }
    else {
      const L = Array.from({ length: n + 1 }, () => new Uint16Array(m + 1));
      for (let i = n - 1; i >= 0; i--) for (let j = m - 1; j >= 0; j--)
        L[i][j] = X[i] === Y[j] ? L[i + 1][j + 1] + 1 : Math.max(L[i + 1][j], L[i][j + 1]);
      const push = (arr, flag, ch) => { const l = arr[arr.length - 1]; if (l[0] === flag) l[1] += ch; else arr.push([flag, ch]); };
      let i = 0, j = 0;
      while (i < n || j < m) {
        if (i < n && j < m && X[i] === Y[j]) { push(sx, 0, X[i++]); push(sy, 0, Y[j++]); }
        else if (j >= m || (i < n && L[i + 1][j] >= L[i][j + 1])) push(sx, 1, X[i++]);
        else push(sy, 1, Y[j++]);
      }
    }
    sx.push([0, x.slice(hx)]); sy.push([0, y.slice(hy)]);
    return [sx, sy];
  }

  // ---------------------------------------------------------------- rendering
  const E = s => esc(String(s));
  function vis(s, ws) {                          // escaped text; with ws, spaces and tabs become visible marks
    s = E(s);
    return ws ? s.replace(/ /g, '<span class="cv-w">·</span>').replace(/\t/g, '<span class="cv-w">⇥</span>') : s;
  }
  function cell(line, segs, ws, cls) {
    const nonl = line.endsWith(NONL), txt = nonl ? line.slice(0, -1) : line;
    let h = segs ? segs.map(([c, t]) => c ? `<mark>${vis(t.replace(NONL, ''), ws)}</mark>` : vis(t.replace(NONL, ''), ws)).join('') : vis(txt, ws);
    if (!h && !nonl) h = ws ? '' : '&#8203;';
    if (ws) h += '<span class="cv-w">¶</span>';
    if (nonl) h += '<span class="cv-nonl">no newline at end</span>';
    return `<td class="cv-t ${cls}">${h}</td>`;
  }
  function diffTable(exp, got, ws) {             // -> html; null when there is nothing to show
    const ops = lcsOps(toLines(exp), toLines(got));
    const rows = []; let dels = [], adds = [], ln = 0, rn = 0;
    const flush = () => {
      const k = Math.max(dels.length, adds.length);
      for (let i = 0; i < k; i++) rows.push({ k: i < dels.length && i < adds.length ? 'chg' : i < dels.length ? 'del' : 'add', l: dels[i], r: adds[i] });
      dels = []; adds = [];
    };
    for (const o of ops) {
      if (o.t === '-') dels.push({ s: o.a, n: ++ln });
      else if (o.t === '+') adds.push({ s: o.b, n: ++rn });
      else { flush(); rows.push({ k: 'eq', l: { s: o.a, n: ++ln }, r: { s: o.b, n: ++rn } }); }
    }
    flush();
    if (!rows.some(r => r.k !== 'eq')) return null;
    const show = rows.map(() => false);
    rows.forEach((r, i) => { if (r.k !== 'eq') for (let d = -CONTEXT; d <= CONTEXT; d++) if (rows[i + d]) show[i + d] = true; });
    let out = '', shown = 0, hidden = 0, cut = 0;
    const gap = () => { if (hidden) { out += `<tr class="cv-gap"><td colspan="4">⋯ ${hidden} matching line${hidden > 1 ? 's' : ''}</td></tr>`; hidden = 0; } };
    rows.forEach((r, i) => {
      if (!show[i]) { hidden++; return; }
      gap();
      if (shown >= MAX_ROWS) { cut++; return; }
      shown++;
      let lsegs = null, rsegs = null;
      if (r.k === 'chg') {
        const a = r.l.s.replace(NONL, ''), b = r.r.s.replace(NONL, '');
        const [x, y] = charSegs(a, b);
        const same = x.filter(s => !s[0]).reduce((n, s) => n + s[1].length, 0);
        if (same / Math.max(a.length, b.length, 1) >= 0.5) {
          lsegs = x; rsegs = y;
          if (r.l.s.endsWith(NONL)) lsegs = null;      // keep the "no newline" tag simple
          if (r.r.s.endsWith(NONL)) rsegs = null;
        }
      }
      const lc = r.k === 'eq' ? '' : 'cv-del', rc = r.k === 'eq' ? '' : 'cv-add';
      const lnum = r.l ? `<td class="cv-ln">${r.l.n}</td>` : '<td class="cv-ln"></td>';
      const rnum = r.r ? `<td class="cv-ln">${r.r.n}</td>` : '<td class="cv-ln"></td>';
      const lt = r.l ? cell(r.l.s, lsegs, ws, lc) : '<td class="cv-t cv-empty"></td>';
      const rt = r.r ? cell(r.r.s, rsegs, ws, rc) : '<td class="cv-t cv-empty"></td>';
      out += `<tr>${lnum}${lt}${rnum}${rt}</tr>`;
    });
    gap();
    if (cut) out += `<tr class="cv-gap"><td colspan="4">⋯ ${cut} more differing line${cut > 1 ? 's' : ''} not shown</td></tr>`;
    return `<table class="cv-diff"><colgroup><col class="cv-c1"><col><col class="cv-c1"><col></colgroup><thead><tr><th></th><th>expected</th><th></th><th>yours</th></tr></thead><tbody>${out}</tbody></table>`;
  }

  // ---------------------------------------------------------------- hints
  const plural = (n, w) => `${n} ${w}${n === 1 ? '' : 's'}`;
  function textHints(exp, got, what, errOfYours) {       // plain-language reasons why two outputs differ
    const h = [], el = toLines(exp).map(l => l.replace(NONL, '')), gl = toLines(got).map(l => l.replace(NONL, ''));
    if (exp === got) return h;
    if (got === '') {
      h.push(`Your script printed nothing on ${what}, but ${plural(el.length, 'line')} ${el.length === 1 ? 'was' : 'were'} expected.` +
        (what === 'stdout' && errOfYours && !/syntax error|not found|denied|No such|unbound/.test(errOfYours) ? ' It did write something to stderr — normal output has to go to stdout (no `>&2`).' : ''));
      return h;
    }
    if (exp === '') { h.push(`Nothing was expected on ${what}, but your script printed ${plural(gl.length, 'line')}.`); return h; }
    if (exp.replace(/\n$/, '') === got.replace(/\n$/, '')) {
      h.push(got.endsWith('\n') ? 'Your output ends with an extra newline.' : 'Your output is missing the final newline (e.g. `printf` without `\\n`, or `echo -n`).');
      return h;
    }
    if ([...el].sort().join('\n') === [...gl].sort().join('\n')) { h.push('The same lines, but in a different order.'); return h; }
    if (exp.toLowerCase() === got.toLowerCase()) { h.push('The text is right but upper/lower case differs.'); return h; }
    if (el.filter(l => l.trim()).join('\n') === gl.filter(l => l.trim()).join('\n')) { h.push('Only blank lines differ (extra or missing empty lines).'); return h; }
    if (exp.replace(/\s+/g, ' ').trim() === got.replace(/\s+/g, ' ').trim()) { h.push('The words match; only the spaces, tabs or line breaks differ — turn on "show whitespace".'); return h; }
    if (exp.replace(/\d+/g, '#') === got.replace(/\d+/g, '#')) h.push('The layout matches but some numbers differ — check what is counted or computed.');
    if (/\$[A-Za-z_{(]/.test(got) && !/\$[A-Za-z_{(]/.test(exp)) h.push('Your output contains a literal `$…`: the variable or command was not expanded (single quotes?).');
    if (/\\[nt]/.test(got) && !/\\[nt]/.test(exp)) h.push('Your output contains a literal `\\n` or `\\t`: use `echo -e` or `printf` for escape sequences.');
    if (!h.length) {
      if (gl.length < el.length && el.slice(0, gl.length).join('\n') === gl.join('\n')) h.push(`Your output stops after line ${gl.length}; ${plural(el.length - gl.length, 'more line')} expected.`);
      else if (gl.length > el.length && gl.slice(0, el.length).join('\n') === el.join('\n')) h.push(`Your output has ${plural(gl.length - el.length, 'extra line')} after the expected output.`);
      else if (gl.length !== el.length) h.push(`${plural(el.length, 'line')} expected, ${gl.length} printed.`);
    }
    return h;
  }
  function parseFs(s) {
    const meta = new Map(), hash = new Map();
    for (const l of s.split('\n')) {
      let m;
      if ((m = /^([0-9a-f]{32})  (.+)$/.exec(l))) hash.set(m[2], m[1]);
      else if ((m = /^(\S) (\S+) (\d+) (.*?)(?: -> (.*))?$/.exec(l))) {
        const rest = (m[5] || '').split(/\s+/).filter(Boolean);       // what follows " -> ": link target, owner:group, modification time
        const time = rest.find(t => /^\d{4}-\d\d-\d\d_\d\d:\d\d$/.test(t)), owner = rest.find(t => t !== time && /^[\w.-]+:[\w.-]+$/.test(t));
        meta.set(m[4], { type: m[1], perms: m[2], links: m[3], owner, time, target: rest.filter(t => t !== time && t !== owner).join(' ') });
      }
    }
    return { meta, hash };
  }
  function fsHints(exp, got) {
    const e = parseFs(exp), g = parseFs(got), h = [], list = a => a.slice(0, 4).map(x => '`' + x + '`').join(', ') + (a.length > 4 ? ` … (${a.length})` : '');
    const missing = [...e.meta.keys()].filter(p => !g.meta.has(p)), extra = [...g.meta.keys()].filter(p => !e.meta.has(p));
    if (missing.length) h.push(`Missing from the result: ${list(missing)}.`);
    if (extra.length) h.push(`Not expected in the result: ${list(extra)}.`);
    for (const [p, a] of e.meta) {
      const b = g.meta.get(p); if (!b) continue;
      if (a.type !== b.type) h.push(`\`${p}\` should be ${a.type === 'd' ? 'a directory' : a.type === 'l' ? 'a symbolic link' : 'a regular file'}.`);
      else if (a.perms !== b.perms) h.push(`\`${p}\` has permissions ${b.perms}, expected ${a.perms}.`);
      else if (a.owner !== b.owner) h.push(`\`${p}\` is owned by ${b.owner}, expected ${a.owner}.`);
      else if (a.links !== b.links) h.push(`\`${p}\` has ${b.links} link(s), expected ${a.links}.`);
      else if (a.target !== b.target) h.push(`\`${p}\` points to ${b.target || 'nothing'}, expected ${a.target || 'nothing'}.`);
      else if (a.time !== b.time) h.push(`The modification time of \`${p}\` is ${b.time}, expected ${a.time}.`);
    }
    const diffc = [...e.hash.keys()].filter(p => g.hash.has(p) && g.hash.get(p) !== e.hash.get(p));
    if (diffc.length) h.push(`The content of ${list(diffc)} differs from the expected.`);
    return h.length > 8 ? [...h.slice(0, 8), `… and ${h.length - 8} more differences.`] : h;
  }
  function exitHints(c) {
    const h = [], e = c.ref_code, g = c.usr_code;
    if (g === 124) h.push('Your script was stopped after the time limit: an endless loop, or it waits for input that never comes.');
    else if (g === 127) h.push('Exit 127 means a command was not found: check the spelling of the command or script name.');
    else if (g === 126) h.push('Exit 126 means a file could not be executed (permissions, or a directory).');
    else if (e === 0 && g !== 0) h.push(`Your script ended with an error (exit ${g}) where success (0) was expected.`);
    else if (e !== 0 && g === 0) h.push(`Your script should fail here with exit ${e} (\`exit ${e}\`); it exited 0.`);
    else if (e !== g) h.push(`Exit code ${g}, expected ${e}.`);
    return h;
  }
  function errHints(err) {
    const h = [];
    if (/syntax error|unexpected (token|end of file)/.test(err)) h.push('bash reports a syntax error: look for a missing `fi`, `done`, `esac`, a quote or a bracket.');
    if (/command not found/.test(err)) h.push('"command not found": a misspelled command, a missing `$` or a space around `=` in an assignment.');
    if (/unbound variable/.test(err)) h.push('A variable is used before it is set.');
    if (/Permission denied/.test(err)) h.push('"Permission denied": check the permissions of the file or directory you are using.');
    if (/No such file or directory/.test(err)) h.push('"No such file or directory": the path is wrong or relative to the wrong directory.');
    if (/\[: .*(expected|unary|binary)/.test(err)) h.push('`[` complained about its arguments: quote your variables, `[ "$x" = y ]`, and keep the spaces inside the brackets.');
    return h;
  }

  // ---------------------------------------------------------------- one case
  const shell = s => /^[\w@%+=:,.\/-]+$/.test(s) ? s : `'${s.replace(/'/g, `'\\''`)}'`;
  function localArgs(c, sb) {                    // the checker's sandbox paths, as seen from the work folder
    const fix = a => sb ? a.split(sb + '/work/').join('').split(sb + '/work').join('.').split(sb + '/home').join('~') : a;
    return (c.args || []).map(a => shell(fix(a))).join(' ');
  }
  function playCommand(c, rep, dirs) {           // typed in the terminal: the checker's run, by hand
    const args = (c.args || []).map(a => shell(rep.sb ? a.split(rep.sb + '/work').join(dirs.work).split(rep.sb + '/home').join(dirs.home) : a)).join(' ');
    const env = [`HOME=${shell(dirs.home)}`, 'LANG=en_US.UTF-8', 'TZ=Europe/Madrid', ...(rep.env || []).map(e => shell(rep.sb ? e.split(rep.sb + '/work').join(dirs.work).split(rep.sb + '/home').join(dirs.home) : e))].join(' ');
    return `${rep.root ? 'sudo env ' : ''}${env} bash ${shell(dirs.script)}${args ? ' ' + args : ''}${c.stdin && dirs.stdin ? ' < ' + shell(dirs.stdin) : ''}`;
  }
  function caseHTML(c, rep, i, ws, canTry) {
    const compare = rep.compare || [], hints = [];
    const inDetail = k => (c.detail || []).includes(k);
    for (const f of c.fails || []) if (!/^(stdout|stderr) differs$|^resulting (files|state) differ|^exit code:/.test(f)) hints.push(E(f));
    if (inDetail('stdout')) hints.push(...textHints(c.ref_out, c.usr_out, 'stdout', c.usr_err).map(E));
    if (inDetail('stderr')) hints.push(...textHints(c.ref_err, c.usr_err, 'stderr').map(E));
    if (inDetail('fs')) hints.push(...fsHints(c.ref_fs || '', c.usr_fs || '').map(E));
    if (c.ref_code !== c.usr_code && compare.includes('exit')) hints.push(...exitHints(c).map(E));
    hints.push(...errHints(c.usr_err || '').map(E));
    if (['ref_out', 'usr_out', 'ref_err', 'usr_err', 'ref_fs', 'usr_fs'].some(k => (c[k] || '').length >= 19990)) hints.push('Very long output: only the first 20000 characters are shown and compared here.');
    const blocks = [];
    const add = (label, a, b, note) => { const t = diffTable(a, b, ws); if (t) blocks.push(`<div class="cv-blk"><div class="cv-lbl">${label}${note ? ` <span class="hint">${note}</span>` : ''}</div>${t}</div>`); };
    if (inDetail('stdout')) add('stdout', c.ref_out, c.usr_out, rep.sorted ? '(compared ignoring line order)' : '');
    if (inDetail('stderr')) add('stderr', c.ref_err, c.usr_err);
    if (inDetail('fs')) add('files <span class="hint">(type, permissions, links, path / content hash)</span>', c.ref_fs || '', c.usr_fs || '');
    if (inDetail('capture')) add('state', c.ref_capture || '', c.usr_capture || '');
    if (c.usr_err && !inDetail('stderr')) blocks.push(`<div class="cv-blk"><div class="cv-lbl">your stderr</div><pre class="cv-pre">${E(c.usr_err.split('\n').slice(0, 8).join('\n'))}</pre></div>`);
    const stdin = c.stdin ? `<details class="cv-in"><summary>input given on stdin (${plural(toLines(c.stdin).length, 'line')})</summary><pre class="cv-pre">${E(c.stdin.split('\n').slice(0, 15).join('\n'))}${toLines(c.stdin).length > 15 ? '\n…' : ''}</pre></details>` : '';
    const args = localArgs(c, rep.sb);
    const dup = c.same ? `same in ${plural(c.same, 'other fixture')}` : '';
    const where = [dup, rep.nargs > 1 && `argument set ${c.index + 1} of ${rep.nargs}`, !c.same && rep.seeds > 1 && `fixture ${Math.round(c.seed / 7919)} of ${rep.seeds}`].filter(Boolean).join(' · ');
    const ranWith = `Ran: <code>bash ${E(rep.script)}${args ? ' ' + E(args) : ''}</code>`;
    const wsCtl = blocks.length ? `<label class="cv-ws"><input type="checkbox" data-act="ws" data-i="${i}"${ws ? ' checked' : ''}> show whitespace</label>` : '';
    const tryBtn = canTry ? `<button class="cv-try" data-act="try" data-i="${i}" title="Builds this case's files in a separate folder (your practice folder is untouched) and types the command in the terminal">▶ Try with these test files</button>` : '';
    return `<section class="cv-case" data-i="${i}">
      <div class="cv-head"><span class="cv-bad">✘</span> <b>Failed</b>${where ? ' · ' + where : ''}<span class="cv-sp"></span>${wsCtl}${tryBtn}</div>
      <div class="cv-ran">${ranWith}</div>${stdin}
      ${hints.length ? `<ul class="cv-hints">${hints.map(x => `<li>${x}</li>`).join('')}</ul>` : ''}
      ${blocks.join('')}
    </section>`;
  }

  // ---------------------------------------------------------------- the result box
  // opts.play(c) -> Promise: shows "Try with these test files" and runs it for a case (the page knows its terminal)
  function show(body, res, opts = {}) {
    const text = res.text.replace(TRAILER, ''), rep = res.report;
    const plain = () => { body.innerHTML = ansiToHtml(text); body._cv = null; };
    if (!rep || !rep.cases || !rep.cases.length || res.code === '0') return plain();
    try { rich(); } catch (e) { console.error('check view', e); plain(); }   // never leave the result box (or the Check button) stuck
    function rich() {
      if (rep.sb) for (const c of rep.cases) for (const k of ['ref_out', 'usr_out', 'ref_err', 'usr_err'])   // the checker's sandbox folders, as the learner sees them
        c[k] = (c[k] || '').split(rep.sb + '/bin/').join('').split(rep.sb + '/work/').join('').split(rep.sb + '/work').join('.').split(rep.sb + '/home').join('~');
      const seen = new Map();                     // the same failure in several fixtures is shown once
      rep.cases = rep.cases.filter(c => {
        const sig = JSON.stringify([c.args, c.stdin, c.ref_out, c.usr_out, c.ref_err, c.usr_err, c.ref_code, c.usr_code, c.ref_fs, c.usr_fs, c.fails]);
        if (seen.has(sig)) { seen.get(sig).same = (seen.get(sig).same || 0) + 1; return false; }
        seen.set(sig, c); return true;
      });
      const ws = rep.cases.map(c => whitespaceOnly(c));
      const state = { rep, ws, opts, c: rep.cases };
      const first = text.split('\n')[0];
      const render = () => {
        const more = rep.bad - rep.cases.reduce((n, c) => n + 1 + (c.same || 0), 0);
        body.innerHTML = `<div class="cv">
          <div class="cv-top">${ansiToHtml(first)} <span class="hint">· ${rep.bad} of ${rep.ncase} test run${rep.ncase === 1 ? '' : 's'} failed</span></div>
          ${rep.cases.map((c, i) => caseHTML(c, rep, i, state.ws[i], !!opts.play)).join('')}
          ${more > 0 ? `<div class="cv-more hint">… and ${more} more failed run${more === 1 ? '' : 's'}; fix these first.</div>` : ''}
        </div>`;
      };
      state.render = render; body._cv = state; render();
      if (!body._cvBound) {
        body._cvBound = true;
        body.addEventListener('click', ev => {
          const b = ev.target.closest('[data-act]'), st = body._cv;
          if (!b || !st) return;
          const i = Number(b.dataset.i);
          if (b.dataset.act === 'ws') { st.ws[i] = b.checked; st.render(); }
          else if (b.dataset.act === 'try' && st.opts.play) {
            b.disabled = true;
            Promise.resolve(st.opts.play(st.c[i], st.rep)).finally(() => { b.disabled = false; });
          }
        });
      }
    }
  }
  function whitespaceOnly(c) {                   // start with the marks on when only spaces/tabs differ
    const a = c.ref_out || '', b = c.usr_out || '';
    return a !== b && (c.detail || []).includes('stdout') && a.replace(/\s+/g, '') === b.replace(/\s+/g, '') && a.split('\n').length === b.split('\n').length;
  }

  return { run, show, playCommand };
})();
