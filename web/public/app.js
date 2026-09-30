// bash stash — single page app
'use strict';
const $ = s => document.querySelector(s);
const state = {
  index: [],        // topics with exercises
  flat: [],         // all exercises in order
  current: null,    // exercise details
  mode: 'term',     // 'term' | 'code'
  codeFor: null,    // exercise id VS Code is currently opened on
};

// ------------------------------------------------------------------ theme
function currentTheme() { return document.documentElement.dataset.theme || 'dark'; }
const XTERM_THEMES = {
  dark:  { background: '#0b0d10', foreground: '#d7dce2', cursor: '#3fb950', selectionBackground: '#22303d' },
  light: { background: '#f3f4f6', foreground: '#1f2328', cursor: '#1a7f37', selectionBackground: '#cfe0f5',
           black: '#24292f', red: '#cf222e', green: '#116329', yellow: '#7d4e00', blue: '#0969da',
           magenta: '#8250df', cyan: '#1b7c83', white: '#6e7781', brightBlack: '#57606a', brightWhite: '#8c959f' },
};
function applyTheme(t, sync = true) {
  document.documentElement.dataset.theme = t;
  try { localStorage.setItem('theme', t); } catch { /* private mode */ }
  $('#theme-btn').textContent = t === 'dark' ? '☀' : '☾';
  if (term) term.options.theme = XTERM_THEMES[t];
  if (sync) fetch('/api/theme', { method: 'POST', headers: { 'Content-Type': 'application/json' },
                                  body: JSON.stringify({ theme: t }) })
    .then(() => { // VS Code only reads its theme when it loads
      if (state.codeFor) { state.codeFor = null; if (state.mode === 'code') openVSCode(); }
    }).catch(() => {});
}
$('#theme-btn').onclick = () => applyTheme(currentTheme() === 'dark' ? 'light' : 'dark');

// ------------------------------------------------------------------ helpers
const STATUS = {
  pass: { dot: '✔', label: 'passed' },
  attempted: { dot: '●', label: 'in progress' },
  viewed: { dot: '◉', label: 'solution viewed' },
  new: { dot: '○', label: 'not started' },
};
const esc = s => s.replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

// ANSI (the checker's colours) -> HTML
function ansiToHtml(text) {
  let open = 0, out = '';
  const parts = esc(text).split(/\x1b\[([0-9;]*)m/);
  for (let i = 0; i < parts.length; i++) {
    if (i % 2 === 0) { out += parts[i]; continue; }
    const codes = parts[i].split(';').filter(Boolean).map(Number);
    if (codes.length === 0 || codes.includes(0)) { out += '</span>'.repeat(open); open = 0; continue; }
    const cls = codes.map(c => ({ 1: 'ansi-bold', 2: 'ansi-dim', 31: 'ansi-red', 32: 'ansi-green', 33: 'ansi-yellow' }[c])).filter(Boolean);
    if (cls.length) { out += `<span class="${cls.join(' ')}">`; open++; }
  }
  return out + '</span>'.repeat(open);
}

// ------------------------------------------------------------------ sidebar
async function loadIndex() {
  state.index = await (await fetch('/api/index')).json();
  state.flat = state.index.flatMap(t => t.exercises);
  renderSidebar();
}

function renderSidebar() {
  const q = $('#search').value.trim().toLowerCase();
  const hidePassed = $('#hide-passed').checked;
  const openTopics = new Set([...document.querySelectorAll('.topic[open]')].map(d => d.dataset.topic));
  const cur = state.current && state.current.id;
  const nav = $('#topics');
  nav.innerHTML = '';
  let total = 0, passed = 0;
  for (const t of state.index) {
    const ex = t.exercises.filter(e =>
      (!q || `${e.id} ${e.title} ${e.cmds}`.toLowerCase().includes(q)) && !(hidePassed && e.status === 'pass'));
    const p = t.exercises.filter(e => e.status === 'pass').length;
    total += t.exercises.length; passed += p;
    if (ex.length === 0) continue;
    const d = document.createElement('details');
    d.className = 'topic';
    d.dataset.topic = t.id;
    d.open = !!q || openTopics.has(t.id) || (cur && cur.startsWith(t.id));
    d.innerHTML = `<summary><span class="t-name">${t.id} · ${esc(t.title)}</span><span class="t-count">${p}/${t.exercises.length}</span></summary>
      <div class="t-bar"><div style="width:${100 * p / t.exercises.length}%"></div></div>`;
    for (const e of ex) {
      const a = document.createElement('a');
      a.className = 'ex-item' + (e.id === cur ? ' current' : '');
      a.href = `#/ex/${e.id}`;
      a.title = `${e.title} — ${STATUS[e.status].label}`;
      a.innerHTML = `<span class="dot ${e.status}">${STATUS[e.status].dot}</span><span class="ex-id">${e.id}</span>
        <span class="ex-name">${esc(e.title)}</span>`;
      d.appendChild(a);
    }
    nav.appendChild(d);
  }
  $('#overall-fill').style.width = `${total ? 100 * passed / total : 0}%`;
  $('#overall-text').textContent = `${passed}/${total}`;
  const curEl = nav.querySelector('.ex-item.current');
  if (curEl && !nav.dataset.scrolled) { curEl.scrollIntoView({ block: 'center' }); nav.dataset.scrolled = 1; }
}
$('#search').oninput = renderSidebar;
$('#hide-passed').onchange = renderSidebar;

// ------------------------------------------------------------------ exercise view
async function openExercise(id) {
  const r = await fetch(`/api/exercise/${id}`);
  if (!r.ok) return;
  const ex = await r.json();
  state.current = ex;
  $('#ex-topic').textContent = ex.topic;
  $('#ex-title').textContent = `${ex.id} · ${ex.title}`;
  $('#ex-level').textContent = '★'.repeat(ex.level) + '☆'.repeat(5 - ex.level);
  $('#ex-cmds').textContent = ex.cmds;
  setStatus(ex.status);
  $('#answer-path').textContent = 'answer: ' + ex.answer.replace(/^\/home\/alumno\/lab\//, '');
  $('#edit-btn').textContent = ex.quiz ? 'nano answer.txt' : 'nano answer.sh';
  const md = ex.readme.replace(/\n---\n[\s\S]*$/, ''); // footer is about the CLI; the buttons replace it
  $('#readme').innerHTML = marked.parse(md);
  $('#result').classList.add('hidden');
  $('#statement-pane').scrollTop = 0;
  document.title = `${ex.id} · ${ex.title} — bash stash`;
  renderSidebar();
  if (state.mode === 'code') openVSCode();
}

function setStatus(s) {
  const b = $('#ex-status');
  b.className = 'badge ' + s;
  b.textContent = STATUS[s].label;
  const e = state.flat.find(x => state.current && x.id === state.current.id);
  if (e) e.status = s;
}

function neighbour(delta) {
  const i = state.flat.findIndex(e => state.current && e.id === state.current.id);
  const n = state.flat[i + delta];
  if (n) location.hash = `#/ex/${n.id}`;
}
$('#prev-btn').onclick = () => neighbour(-1);
$('#next-btn').onclick = () => neighbour(1);

// ------------------------------------------------------------------ check
let checking = false;
async function runCheck() {
  if (!state.current || checking) return;
  checking = true;
  const btn = $('#check-btn');
  btn.disabled = true; btn.textContent = '… checking';
  const box = $('#result'), body = $('#result-body');
  box.classList.remove('hidden', 'pass', 'fail');
  $('#result-title').textContent = `Checking ${state.current.id}…`;
  body.innerHTML = '';
  let text = '';
  try {
    const r = await fetch(`/api/check/${state.current.id}`, { method: 'POST' });
    const reader = r.body.getReader(), dec = new TextDecoder();
    for (;;) {
      const { value, done } = await reader.read();
      if (done) break;
      text += dec.decode(value, { stream: true });
      body.innerHTML = ansiToHtml(text);
    }
  } catch (e) { text += `\n${e}`; body.textContent = text; }
  const code = ([...text.matchAll(/\[exit (\d+)\]/g)].pop() || [])[1];
  const ok = code === '0', notAttempted = code === '3';
  box.classList.add(ok ? 'pass' : 'fail');
  $('#result-title').textContent = ok ? '✔ Passed' : notAttempted ? 'Not attempted yet' : '✘ Not yet';
  body.innerHTML = ansiToHtml(text.replace(/\n?\x1b\[2m\[exit \d+\]\x1b\[0m\s*$/, ''));
  try {
    await loadIndex();
    const e = state.flat.find(x => x.id === state.current.id);
    if (e) { setStatus(e.status); state.current.status = e.status; }
  } finally {
    btn.disabled = false; btn.textContent = '▶ Check';
    checking = false;
  }
}
$('#check-btn').onclick = runCheck;
$('#result-close').onclick = () => $('#result').classList.add('hidden');
document.addEventListener('keydown', ev => {
  if ((ev.ctrlKey || ev.metaKey) && ev.key === 'Enter') { ev.preventDefault(); runCheck(); }
});

// ------------------------------------------------------------------ solution
// ------------------------------------------------------------------ info & reference (glossary)
function glossaryHTML(entries, linkify) {
  const known = entries.filter(e => e.desc);
  if (!known.length) return '<p class="hint">No commands with a write-up yet for this one.</p>';
  return known.map(e => `<div class="gl-item"><code>${linkify
    ? `<a href="#" data-goto-cmd="${esc(e.key)}">${esc(e.name)}</a>` : esc(e.name)}</code><p>${esc(e.desc)}</p></div>`).join('');
}

// The single-command focused view: same name+description, plus a usage line, an options table and
// worked examples when the glossary entry has them (older/rarer entries fall back gracefully).
function focusedGlossaryHTML(e) {
  let html = `<code>${esc(e.name)}</code><p>${esc(e.desc)}</p>`;
  if (e.usage) html += `<div class="gl-usage">${esc(e.usage)}</div>`;
  if (e.options && e.options.length) {
    html += `<h4>Options</h4><div class="gl-opts">${e.options.map(o =>
      `<div class="opt"><code>${esc(o.flag)}</code><span>${esc(o.desc)}</span></div>`).join('')}</div>`;
  }
  if (e.examples && e.examples.length) {
    html += `<h4>Examples</h4><div class="gl-examples">${e.examples.map(x =>
      `<div class="ex"><code>${esc(x.cmd)}</code><span>${esc(x.desc)}</span></div>`).join('')}</div>`;
  }
  return html;
}
$('#info-btn').onclick = () => {
  if (!state.current) return;
  $('#info-title').textContent = `Commands used in ${state.current.id}`;
  $('#info-body').innerHTML = glossaryHTML(explainCmds(state.current.cmds), true);
  $('#info-dialog').showModal();
};
$('#info-body').addEventListener('click', ev => {
  const el = ev.target.closest('[data-goto-cmd]');
  if (!el) return;
  $('#info-dialog').close();
  location.hash = `#/reference/cmd/${encodeURIComponent(el.dataset.gotoCmd)}`;
});

// An index of every topic's distinct commands, and every exercise each command appears in (so a
// focused command view can both link back to its categories and show per-exercise progress there,
// the same way the exercise sidebar does for a whole topic).
let refTopics = null;       // [{id, title, cmds: [{key,name,desc}, ...]}]
let refCmdExercises = null; // key -> [{id, title, topicId, topicTitle}]
let refSel = { type: 'all' }; // {type:'all'} | {type:'topic', id} | {type:'cmd', key}

function buildReferenceIndex() {
  refTopics = state.index.map(t => {
    const cmds = new Map();
    for (const e of t.exercises) for (const c of explainCmds(e.cmds)) if (c.desc && !cmds.has(c.key)) cmds.set(c.key, c);
    return { id: t.id, title: t.title, cmds: [...cmds.values()].sort((a, b) => a.name.localeCompare(b.name)) };
  });
  refCmdExercises = new Map();
  for (const t of state.index) for (const e of t.exercises) for (const c of explainCmds(e.cmds)) {
    if (!c.desc) continue;
    if (!refCmdExercises.has(c.key)) refCmdExercises.set(c.key, []);
    refCmdExercises.get(c.key).push({ id: e.id, title: e.title, topicId: t.id, topicTitle: t.title });
  }
}

function topicSection(t) {
  return `<section class="ref-topic" id="ref-topic-${esc(t.id)}">
    <h3><a href="#" data-action="topic" data-id="${esc(t.id)}">${esc(t.id)} · ${esc(t.title)}</a></h3>
    <div class="glossary-list">${glossaryHTML(t.cmds)}</div>
  </section>`;
}

// The "used in" list for a focused command: a progress bar + each exercise with the same pass/
// attempted/viewed/new dot the exercise sidebar uses, freshly read from state.flat every render.
function usedInHTML(key) {
  const uses = refCmdExercises.get(key) || [];
  if (!uses.length) return '';
  const live = uses.map(u => ({ ...u, ...state.flat.find(e => e.id === u.id) }));
  const passed = live.filter(e => e.status === 'pass').length;
  const rows = live.map(e => `<a href="#/ex/${e.id}"><span class="dot ${e.status}">${STATUS[e.status].dot}</span>
    <span class="ex-id">${e.id}</span> ${esc(e.title)}<span class="ex-topic-label">${esc(e.topicTitle)}</span></a>`).join('');
  return `<div class="gl-seealso">
    <div class="gl-seealso-head">
      <strong>Used in ${live.length} exercise${live.length === 1 ? '' : 's'}</strong>
      <div class="bar"><div style="width:${100 * passed / live.length}%"></div></div>
      <span class="t-count">${passed}/${live.length}</span>
    </div>
    <div class="gl-ex-list">${rows}</div>
  </div>`;
}

function renderReferenceContent() {
  const content = $('#reference-content');
  if (refSel.type === 'topic') {
    const t = refTopics.find(x => x.id === refSel.id);
    content.innerHTML = t ? topicSection(t) : '<p class="ref-empty">Not found.</p>';
  } else if (refSel.type === 'cmd') {
    const entry = refTopics.flatMap(t => t.cmds).find(c => c.key === refSel.key);
    content.innerHTML = entry ? `<div class="gl-focus">${focusedGlossaryHTML(entry)}${usedInHTML(refSel.key)}</div>`
      : '<p class="ref-empty">Not found.</p>';
  } else {
    content.innerHTML = refTopics.map(t => topicSection(t)).join('');
  }
  content.scrollTop = 0;
}

function renderReferenceNav() {
  $('#reference-all').classList.toggle('current', refSel.type === 'all');
  $('#reference-tree').innerHTML = refTopics.map(t => `
    <div class="ref-nav-topic${refSel.type !== 'all' ? ' open' : ''}" data-topic="${esc(t.id)} ${esc(t.title.toLowerCase())}">
      <button class="ref-nav-topic-head${refSel.type === 'topic' && refSel.id === t.id ? ' current' : ''}" data-action="topic" data-id="${esc(t.id)}">
        <span class="chev">▸</span><span class="t-name">${esc(t.id)} · ${esc(t.title)}</span><span class="count">${t.cmds.length}</span>
      </button>
      <div class="ref-nav-cmds">${t.cmds.map(c => `<a href="#" class="ref-nav-cmd${refSel.type === 'cmd' && refSel.key === c.key ? ' current' : ''}"
        data-action="cmd" data-key="${esc(c.key)}" data-name="${esc(c.name.toLowerCase())}" title="${esc(c.name)}">${esc(c.name)}</a>`).join('')}</div>
    </div>`).join('');
}

function renderReference() {
  renderReferenceNav();
  renderReferenceContent();
}

$('#reference-nav').addEventListener('click', ev => {
  const el = ev.target.closest('[data-action]');
  if (!el) return;
  ev.preventDefault();
  if (el.dataset.action === 'topic') {
    const node = el.closest('.ref-nav-topic');
    if (node && refSel.type === 'topic' && refSel.id === el.dataset.id) node.classList.toggle('open');
    else if (node) node.classList.add('open');
    refSel = { type: 'topic', id: el.dataset.id };
  } else if (el.dataset.action === 'cmd') {
    refSel = { type: 'cmd', key: el.dataset.key };
  }
  renderReference();
});
$('#reference-content').addEventListener('click', ev => {
  const el = ev.target.closest('[data-action="topic"]');
  if (!el) return;
  ev.preventDefault();
  refSel = { type: 'topic', id: el.dataset.id };
  renderReference();
});
$('#reference-all').onclick = ev => { ev.preventDefault(); refSel = { type: 'all' }; renderReference(); };
$('#reference-back').onclick = ev => {
  ev.preventDefault();
  if (state.lastExerciseId) location.hash = `#/ex/${state.lastExerciseId}`;
  else if (history.length > 1) history.back();
  else location.hash = '#/ex/0101';
};
$('#theme-btn-ref').onclick = () => applyTheme(currentTheme() === 'dark' ? 'light' : 'dark');
$('#reference-search').oninput = () => {
  const q = $('#reference-search').value.trim().toLowerCase();
  for (const node of document.querySelectorAll('.ref-nav-topic')) {
    const topicHit = !q || node.dataset.topic.includes(q);
    let anyCmd = false;
    for (const a of node.querySelectorAll('.ref-nav-cmd')) {
      const hit = !q || topicHit || a.dataset.name.includes(q);
      a.classList.toggle('hidden', !hit);
      anyCmd = anyCmd || hit;
    }
    node.classList.toggle('hidden', !(topicHit || anyCmd));
    if (q) node.classList.add('open'); else if (refSel.type === 'all') node.classList.remove('open');
  }
};

$('#solution-btn').onclick = async () => {
  if (!state.current) return;
  let confirm = false;
  if (state.current.status !== 'pass') {
    const dlg = $('#confirm-dialog');
    dlg.returnValue = '';
    dlg.showModal();
    await new Promise(res => dlg.addEventListener('close', res, { once: true }));
    if (dlg.returnValue !== 'ok') return;
    confirm = true;
  }
  const r = await fetch(`/api/solution/${state.current.id}`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ confirm }) });
  if (!r.ok) return;
  const sol = await r.json();
  $('#sol-title').textContent = `Solution · ${state.current.id} ${state.current.title}`;
  $('#sol-file').textContent = sol.file;
  $('#sol-body').textContent = sol.content;
  $('#solution-dialog').showModal();
  if (state.current.status !== 'pass') { setStatus('viewed'); state.current.status = 'viewed'; renderSidebar(); }
};

// ------------------------------------------------------------------ terminal
let term = null, fit = null, sock = null;
function startTerminal() {
  if (sock) { try { sock.close(); } catch { /* closed */ } }
  if (!term) {
    term = new Terminal({ cursorBlink: true, fontSize: 13, scrollback: 5000,
      fontFamily: 'ui-monospace, "Cascadia Code", "DejaVu Sans Mono", Menlo, monospace',
      theme: XTERM_THEMES[currentTheme()] });
    fit = new FitAddon.FitAddon();
    term.loadAddon(fit);
    term.open($('#term'));
    term.onData(d => { if (sock && sock.readyState === 1) sock.send(JSON.stringify({ t: 'i', d })); });
    term.onResize(({ cols, rows }) => { if (sock && sock.readyState === 1) sock.send(JSON.stringify({ t: 'r', c: cols, r: rows })); });
    new ResizeObserver(() => { if (!$('#term').classList.contains('hidden')) try { fit.fit(); } catch { /* hidden */ } }).observe($('#term'));
  }
  fit.fit();
  term.reset();
  const q = new URLSearchParams({ cols: term.cols, rows: term.rows });
  if (state.current) q.set('ex', state.current.id);
  sock = new WebSocket(`${location.protocol === 'https:' ? 'wss' : 'ws'}://${location.host}/pty?${q}`);
  sock.onmessage = ev => term.write(ev.data);
  sock.onclose = () => term.write('\r\n\x1b[2m[session ended — click "new session" to start another]\x1b[0m\r\n');
  term.focus();
}
function typeInTerminal(cmd) {
  if (state.mode !== 'term') setMode('term');
  if (!sock || sock.readyState !== 1) { startTerminal(); setTimeout(() => typeInTerminal(cmd), 400); return; }
  sock.send(JSON.stringify({ t: 'i', d: cmd + '\r' }));
  term.focus();
}
const shq = s => `'${s.replace(/'/g, `'\\''`)}'`;
$('#restart-btn').onclick = startTerminal;
$('#cd-btn').onclick = async () => {
  if (!state.current) return;
  if (!state.current.playDir) { typeInTerminal(`cd ${shq(state.current.dir)}`); return; }
  $('#cd-btn').disabled = true;
  try {
    const r = await fetch(`/api/reset/${state.current.id}`, { method: 'POST' });
    const j = await r.json();
    if (j.playDir) { state.current.playDir = j.playDir; typeInTerminal(`cd ${shq(j.playDir)} && clear && ls`); }
  } finally { $('#cd-btn').disabled = false; }
};
$('#edit-btn').onclick = () => state.current && typeInTerminal(`nano ${shq(state.current.answer)}`);

// ------------------------------------------------------------------ VS Code
function openVSCode() {
  if (!state.current || state.codeFor === state.current.id) return;
  state.codeFor = state.current.id;
  const pane = $('#code');
  let frame = pane.querySelector('iframe');
  if (!frame) {
    frame = document.createElement('iframe');
    frame.title = 'VS Code';
    frame.allow = 'clipboard-read; clipboard-write';
    pane.appendChild(frame);
  }
  $('#code-placeholder').classList.add('hidden');
  // open the practice folder (the real fixture files, plus answer.sh as a symlink to the tracked
  // file so edits persist) with the answer file open and the file-explorer sidebar out of the way
  const folder = state.current.playDir || state.current.dir;
  const answerInFolder = state.current.playDir
    ? `${state.current.playDir}/${state.current.answer.split('/').pop()}`
    : state.current.answer;
  const payload = JSON.stringify([
    ['openFile', `vscode-remote://${location.host}${answerInFolder}`],
    ['workbench.action.closeSidebar'],
  ]);
  frame.src = `/vscode/?folder=${encodeURIComponent(folder)}&payload=${encodeURIComponent(payload)}`;
}

function setMode(m) {
  state.mode = m;
  const layout = $('#main').dataset.layout || 'default';
  const showTerm = layout !== 'default' || m === 'term';
  const showCode = layout !== 'default' || m === 'code';
  $('#tab-term').classList.toggle('active', m === 'term');
  $('#tab-code').classList.toggle('active', m === 'code');
  $('#tab-term').setAttribute('aria-selected', m === 'term');
  $('#tab-code').setAttribute('aria-selected', m === 'code');
  $('#tab-term').classList.toggle('hidden', layout !== 'default');
  $('#tab-code').classList.toggle('hidden', layout !== 'default');
  $('#term').classList.toggle('hidden', !showTerm);
  $('#code').classList.toggle('hidden', !showCode);
  for (const id of ['#cd-btn', '#edit-btn', '#restart-btn']) $(id).classList.toggle('hidden', layout === 'default' && m !== 'term');
  $('#vsc-reload-btn').classList.toggle('hidden', layout === 'default' && m !== 'code');
  try { localStorage.setItem('mode', m); } catch { /* private mode */ }
  if (showCode) openVSCode();
  if (showTerm) { if (!term) startTerminal(); else { fit.fit(); if (m === 'term') term.focus(); } }
}
$('#tab-term').onclick = () => setMode('term');
$('#tab-code').onclick = () => setMode('code');
$('#vsc-reload-btn').onclick = () => { state.codeFor = null; openVSCode(); };

// ------------------------------------------------------------------ splitters & panel layouts
function makeSplitter(el, varKey) {
  el.onpointerdown = ev => {
    el.setPointerCapture(ev.pointerId); el.classList.add('dragging');
    document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = 'none');
  };
  el.onpointermove = ev => {
    if (!el.classList.contains('dragging')) return;
    const layout = $('#main').dataset.layout;
    const axis = varKey === 'a' ? 'x' : (layout === 'sidebyside' ? 'x' : 'y');
    const r = $('#main-content').getBoundingClientRect();
    const pct = axis === 'x'
      ? Math.min(80, Math.max(15, 100 * (ev.clientX - r.left) / r.width))
      : Math.min(80, Math.max(15, 100 * (ev.clientY - r.top) / r.height));
    $('#main-content').style.setProperty(`--split-${varKey}`, pct + '%');
  };
  el.onpointerup = () => {
    el.classList.remove('dragging');
    document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = '');
    const layout = $('#main').dataset.layout;
    try { localStorage.setItem(`split_${layout}_${varKey}`, $('#main-content').style.getPropertyValue(`--split-${varKey}`)); } catch { /* private mode */ }
    if (fit && !$('#term').classList.contains('hidden')) try { fit.fit(); } catch { /* hidden */ }
  };
}
makeSplitter($('#splitter-a'), 'a');
makeSplitter($('#splitter-b'), 'b');

const LAYOUT_DEFAULTS = {
  default:    { a: '44%' },
  sidebyside: { a: '33%', b: '33%' },
  leftstack:  { a: '50%', b: '45%' },
  vscodeleft: { a: '50%', b: '45%' },
};
function applyLayout(name, opts = {}) {
  if (!LAYOUT_DEFAULTS[name]) name = 'default';
  const main = $('#main'), mc = $('#main-content'), d = LAYOUT_DEFAULTS[name];
  main.dataset.layout = name;
  document.querySelectorAll('.layout-menu-item').forEach(b => b.classList.toggle('current', b.dataset.layout === name));
  $('#splitter-b').classList.toggle('hidden', name === 'default');
  $('#splitter-b').classList.toggle('splitter-h', name === 'leftstack' || name === 'vscodeleft');
  let a = d.a, b = d.b;
  try {
    a = localStorage.getItem(`split_${name}_a`) || d.a;
    if (d.b) b = localStorage.getItem(`split_${name}_b`) || d.b;
  } catch { /* private mode */ }
  mc.style.setProperty('--split-a', a);
  if (b) mc.style.setProperty('--split-b', b);
  setMode(state.mode);
  if (opts.persist !== false) { try { localStorage.setItem('workLayout', name); } catch { /* private mode */ } }
  $('#layout-menu').classList.add('hidden');
  $('#layout-btn').setAttribute('aria-expanded', 'false');
  requestAnimationFrame(() => { if (fit) try { fit.fit(); } catch { /* hidden */ } });
}
document.querySelectorAll('.layout-menu-item').forEach(b => b.onclick = () => applyLayout(b.dataset.layout));
$('#layout-btn').onclick = ev => {
  ev.stopPropagation();
  const hidden = $('#layout-menu').classList.toggle('hidden');
  $('#layout-btn').setAttribute('aria-expanded', String(!hidden));
};
document.addEventListener('click', ev => {
  if (!$('#layout-picker').contains(ev.target)) {
    $('#layout-menu').classList.add('hidden');
    $('#layout-btn').setAttribute('aria-expanded', 'false');
  }
});

// ------------------------------------------------------------------ routing & start
function showReferencePage(show) {
  document.querySelector('.layout').classList.toggle('hidden', show);
  $('#reference-page').classList.toggle('hidden', !show);
}
function route() {
  const refCmd = location.hash.match(/^#\/reference\/cmd\/([^/]+)$/);
  const refTopic = location.hash.match(/^#\/reference\/topic\/([^/]+)$/);
  if (location.hash === '#/reference' || refCmd || refTopic) {
    showReferencePage(true);
    if (!refTopics) buildReferenceIndex();
    if (refCmd) refSel = { type: 'cmd', key: decodeURIComponent(refCmd[1]) };
    else if (refTopic) refSel = { type: 'topic', id: decodeURIComponent(refTopic[1]) };
    else { refSel = { type: 'all' }; $('#reference-search').value = ''; }
    renderReference();
    return;
  }
  showReferencePage(false);
  const m = location.hash.match(/^#\/ex\/(\d{4})$/);
  if (m) { state.lastExerciseId = m[1]; return openExercise(m[1]); }
  const next = state.flat.find(e => e.status !== 'pass') || state.flat[0];
  if (next) location.replace(`#/ex/${next.id}`);
}
window.addEventListener('hashchange', route);

// ------------------------------------------------------------------ sidebar collapse
$('#sidebar-toggle').innerHTML = '<span class="arrow">‹</span>';
$('#sidebar-toggle').onclick = () => {
  const collapsed = document.querySelector('.layout').classList.toggle('sidebar-collapsed');
  $('#sidebar-toggle').title = collapsed ? 'Expand sidebar' : 'Collapse sidebar';
  try { localStorage.setItem('sidebarCollapsed', collapsed ? '1' : ''); } catch { /* private mode */ }
};
try {
  if (localStorage.getItem('sidebarCollapsed')) {
    document.querySelector('.layout').classList.add('sidebar-collapsed');
    $('#sidebar-toggle').title = 'Expand sidebar';
  }
} catch { /* private mode */ }

(async () => {
  applyTheme(currentTheme(), false);
  await loadIndex();
  await route();
  let mode = 'term';
  try { mode = localStorage.getItem('mode') || 'term'; } catch { /* private mode */ }
  state.mode = mode;
  let layout = 'default';
  try { layout = localStorage.getItem('workLayout') || 'default'; } catch { /* private mode */ }
  applyLayout(layout, { persist: false });
})();
