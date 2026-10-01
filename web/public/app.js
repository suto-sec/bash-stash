// bash stash — single page app
'use strict';
const $ = s => document.querySelector(s);
const state = {
  index: [],        // topics with exercises
  flat: [],         // all exercises in order
  current: null,    // exercise details
  mode: 'term',     // 'term' | 'code'
  codeFor: null,    // exercise id VS Code is currently opened on
  activeVSCodeFile: null, // basename of the editor tab currently focused in VS Code, reported via postMessage
  track: 'full',    // 'full' | 'minimal' | 'intermediate' | 'complete'
  introCategory: null, // topic id (e.g. '06') while browsing that category's Introduction refreshers
  theory: null,     // Theory collection id while browsing quizzes (sidebar + main panel switch to them)
  exam: null,       // practice exam id while one is open (its own panel + a sidebar listing its questions)
};
try { state.track = localStorage.getItem('track') || 'full'; } catch { /* private mode */ }
if (state.track === 'complete') state.track = 'full'; // "Complete" was dropped as a choice — identical to Full anyway
try { state.introCategory = localStorage.getItem('introCategory') || null; } catch { /* private mode */ }

// Track tiers (server-computed from which tools/src/*.txt batch an exercise came from):
// 0 = tiny one-concept "Introduction" refresher, never part of any track, only reachable by picking
// its category from the home page. 1 = base (closest to the course material's own examples),
// 2 = added to mirror exam patterns, 3 = later bulk-expansion practice.
// minimal=tier 1, intermediate=tiers 1-2, complete/full=everything except tier 0.
const TRACK_MAX = { minimal: 1, intermediate: 2, complete: 3 };
function visibleInTopic(t, e) {
  if (state.introCategory === 'all') return e.tier === 0;
  if (state.introCategory) return state.introCategory === t.id && e.tier === 0;
  if (e.tier === 0) return false;
  return state.track === 'full' || e.tier <= TRACK_MAX[state.track];
}
function visibleFlat() {
  const out = [];
  for (const t of state.index) for (const e of t.exercises) if (visibleInTopic(t, e)) out.push(e);
  return out;
}

window.addEventListener('message', ev => {
  if (ev.origin !== location.origin) return;
  if (ev.data && ev.data.source === 'bash-stash-vscode') state.activeVSCodeFile = ev.data.activeFile;
});

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
  $('#theme-row-value').textContent = t === 'dark' ? 'Dark' : 'Light';
  if (term) term.options.theme = XTERM_THEMES[t];
  if (sync) fetch('/api/theme', { method: 'POST', headers: { 'Content-Type': 'application/json' },
                                  body: JSON.stringify({ theme: t }) })
    .then(() => { // VS Code only reads its theme when it loads
      if (state.codeFor) { state.codeFor = null; if (state.mode === 'code') openVSCode(); }
    }).catch(() => {});
}
$('#theme-row').onclick = () => applyTheme(currentTheme() === 'dark' ? 'light' : 'dark');

// ------------------------------------------------------------------ settings popup
$('#settings-btn').onclick = ev => {
  ev.stopPropagation();
  const hidden = $('#settings-menu').classList.toggle('hidden');
  $('#settings-btn').setAttribute('aria-expanded', String(!hidden));
};
document.addEventListener('click', ev => {
  if (!$('#settings-picker').contains(ev.target)) {
    $('#settings-menu').classList.add('hidden');
    $('#settings-btn').setAttribute('aria-expanded', 'false');
  }
});

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
  await Theory.load();
  await Exams.load();
  renderSidebar();
}

function renderSidebar() {
  if (state.theory) return Theory.renderSidebar();
  if (state.exam) return Exams.renderSidebar();
  const q = $('#search').value.trim().toLowerCase();
  const hidePassed = $('#hide-passed').checked;
  const openTopics = new Set([...document.querySelectorAll('#topics .topic[open]')].map(d => d.dataset.topic));
  const cur = state.current && state.current.id;
  const nav = $('#topics');
  nav.innerHTML = '';
  let total = 0, passed = 0;
  for (const t of state.index) {
    const trackEx = t.exercises.filter(e => visibleInTopic(t, e));
    if (trackEx.length === 0) continue; // this topic has nothing in the current track
    const ex = trackEx.filter(e =>
      (!q || `${e.id} ${e.title} ${e.cmds}`.toLowerCase().includes(q)) && !(hidePassed && e.status === 'pass'));
    const p = trackEx.filter(e => e.status === 'pass').length;
    total += trackEx.length; passed += p;
    if (ex.length === 0) continue;
    const d = document.createElement('details');
    d.className = 'topic';
    d.dataset.topic = t.id;
    d.open = !!q || openTopics.has(t.id) || (cur && cur.startsWith(t.id));
    d.innerHTML = `<summary><span class="t-name">${t.id} · ${esc(t.title)}</span><span class="t-count">${p}/${trackEx.length}</span></summary>
      <div class="t-bar"><div style="width:${100 * p / trackEx.length}%"></div></div>`;
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
$('#expand-all-btn').onclick = () => document.querySelectorAll('#topics .topic').forEach(d => { d.open = true; });
$('#collapse-all-btn').onclick = () => document.querySelectorAll('#topics .topic').forEach(d => { d.open = false; });

// ------------------------------------------------------------------ exercise view
async function openExercise(id) {
  const r = await fetch(`/api/exercise/${id}`);
  if (!r.ok) return;
  const ex = await r.json();
  state.current = ex;
  state.activeVSCodeFile = null; // repopulated once VS Code (re)loads for this exercise and reports its focused tab
  $('#ex-topic').textContent = ex.topic;
  $('#ex-title').textContent = `${ex.id} · ${ex.title}`;
  $('#ex-level').textContent = '★'.repeat(ex.level) + '☆'.repeat(5 - ex.level);
  $('#ex-cmds').textContent = ex.cmds;
  setStatus(ex.status);
  $('#answer-path').textContent = 'answer: ' + ex.answer.replace(/^\/home\/alumno\/lab\//, '');
  const md = ex.readme.replace(/\n---\n[\s\S]*$/, ''); // footer is about the CLI; the buttons replace it
  $('#readme').innerHTML = marked.parse(md);
  $('#result').classList.add('hidden');
  $('#statement-pane').scrollTop = 0;
  document.title = `${ex.id} · ${ex.title} — bash stash`;
  renderSidebar();
  // VS Code: reload for the new exercise whenever its pane is actually visible — in split/custom
  // layouts that's always (both panes show at once), not just when the Terminal/VS Code tab happens
  // to be set to 'code' (that check only meant something back when the tabbed layout was the only one).
  const layout = $('#main').dataset.layout || 'default';
  if (layout !== 'default' || state.mode === 'code') openVSCode();
  // Terminal: silently cd an already-running session into the new exercise's sandbox, without
  // stealing focus or switching tabs — a fresh session (not started yet) picks up the right
  // exercise on its own once opened, via the ?ex= it's started with.
  if (sock && sock.readyState === 1) {
    const dir = state.current.playDir || state.current.dir;
    sock.send(JSON.stringify({ t: 'i', d: `cd ${shq(dir)} && clear && ls\r` }));
  }
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
  // an attempt focused in VS Code (answer2.sh, ...) is checked instead of the canonical file —
  // it never updates the exercise's official pass/fail status (see lib/engine.sh: check_one)
  const canonical = state.current.answer.split('/').pop();
  const file = state.activeVSCodeFile && state.activeVSCodeFile !== canonical ? state.activeVSCodeFile : null;
  $('#result-title').textContent = file ? `Checking ${file}…` : `Checking ${state.current.id}…`;
  body.innerHTML = '';
  let text = '';
  try {
    const url = `/api/check/${state.current.id}` + (file ? `?file=${encodeURIComponent(file)}` : '');
    const r = await fetch(url, { method: 'POST' });
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
  const suffix = file ? ` (${file}, not saved as the exercise's official result)` : '';
  $('#result-title').textContent = (ok ? '✔ Passed' : notAttempted ? 'Not attempted yet' : '✘ Not yet') + suffix;
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
  if (state.theory || state.exam) return; // the quiz and exam views have their own keys (theory.js, exams.js)
  if ((ev.ctrlKey || ev.metaKey) && ev.key === 'Enter') { ev.preventDefault(); runCheck(); }
});

// ------------------------------------------------------------------ solution
// ------------------------------------------------------------------ info & reference (glossary)
function glossaryHTML(entries, linkify) {
  const known = entries.filter(e => e.desc);
  if (!known.length) return '<p class="hint">No commands with a write-up yet for this one.</p>';
  return known.map(e => {
    const inner = `<code>${esc(e.name)}</code><p>${esc(e.desc)}</p>`;
    // the whole card is the click target, not just the command name inside it
    return linkify ? `<a href="#" class="gl-item" data-goto-cmd="${esc(e.key)}">${inner}</a>` : `<div class="gl-item">${inner}</div>`;
  }).join('');
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
    <div class="glossary-list">${glossaryHTML(t.cmds, true)}</div>
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
  const topicEl = ev.target.closest('[data-action="topic"]');
  if (topicEl) { ev.preventDefault(); refSel = { type: 'topic', id: topicEl.dataset.id }; renderReference(); return; }
  const cmdEl = ev.target.closest('[data-goto-cmd]');
  if (cmdEl) { ev.preventDefault(); location.hash = `#/reference/cmd/${encodeURIComponent(cmdEl.dataset.gotoCmd)}`; }
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

// ------------------------------------------------------------------ VS Code
// openPath forces a reload pointed at that specific file (used to jump to a freshly created
// attempt); with no argument, it's a no-op once already open for this exercise.
function openVSCode(openPath) {
  if (!state.current || (!openPath && state.codeFor === state.current.id)) return;
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
    ['openFile', `vscode-remote://${location.host}${openPath || answerInFolder}`],
    ['workbench.action.closeSidebar'],
  ]);
  frame.src = `/vscode/?folder=${encodeURIComponent(folder)}&payload=${encodeURIComponent(payload)}`;
}
$('#new-attempt-btn').onclick = async () => {
  if (!state.current) return;
  $('#new-attempt-btn').disabled = true;
  try {
    const r = await fetch(`/api/attempt/${state.current.id}`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ from: state.activeVSCodeFile }),
    });
    const j = await r.json();
    if (j.error) { alert(j.error); return; }
    openVSCode(j.openPath);
  } finally { $('#new-attempt-btn').disabled = false; }
};

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
  // in the default (tabbed) layout, #cpanel-term/#cpanel-code overlap at the same position — hiding
  // only the inner #term/#code left the INACTIVE tab's wrapper (an opaque, non-empty box) painted on
  // top of the active one, blanking it out. The wrapper itself must hide too.
  $('#cpanel-term').classList.toggle('hidden', !showTerm);
  $('#cpanel-code').classList.toggle('hidden', !showCode);
  for (const id of ['#cd-btn', '#restart-btn']) $(id).classList.toggle('hidden', layout === 'default' && m !== 'term');
  $('#new-attempt-btn').classList.toggle('hidden', layout === 'default' && m !== 'code');
  try { localStorage.setItem('mode', m); } catch { /* private mode */ }
  if (showCode) openVSCode();
  if (showTerm) { if (!term) startTerminal(); else { fit.fit(); if (m === 'term') term.focus(); } }
}
$('#tab-term').onclick = () => setMode('term');
$('#tab-code').onclick = () => setMode('code');

// ------------------------------------------------------------------ custom layout (freeform drag-to-dock)
const PANEL_EL = { instr: $('#cpanel-instr'), term: $('#cpanel-term'), code: $('#cpanel-code') };
let customTree = null;
let customSplitters = []; // rebuilt by computeRects() every render: [{node, axis, rect, parentRect}, ...]

function defaultCustomTree() {
  return { dir: 'row', ratio: 44,
    a: { panel: 'instr' },
    b: { dir: 'row', ratio: 50, a: { panel: 'term' }, b: { panel: 'code' } } };
}
function loadCustomTree() {
  try {
    const raw = localStorage.getItem('customLayoutTree');
    customTree = raw ? JSON.parse(raw) : defaultCustomTree();
  } catch { customTree = defaultCustomTree(); }
}
function saveCustomTree() {
  try { localStorage.setItem('customLayoutTree', JSON.stringify(customTree)); } catch { /* private mode */ }
}
function locateNode(root, pred, parent = null, key = null) {
  if (pred(root)) return { node: root, parent, key };
  if (root.panel) return null;
  return locateNode(root.a, pred, root, 'a') || locateNode(root.b, pred, root, 'b');
}
function removeLeaf(root, panelName) {
  const loc = locateNode(root, n => n.panel === panelName);
  if (!loc || !loc.parent) return root;
  const sibling = loc.key === 'a' ? loc.parent.b : loc.parent.a;
  const parentLoc = locateNode(root, n => n === loc.parent);
  if (!parentLoc || !parentLoc.parent) return sibling;
  parentLoc.parent[parentLoc.key] = sibling;
  return root;
}
function insertLeaf(root, targetPanel, draggedPanel, edge) {
  const loc = locateNode(root, n => n.panel === targetPanel);
  if (!loc) return root;
  const dir = (edge === 'left' || edge === 'right') ? 'row' : 'col';
  const dragged = { panel: draggedPanel };
  const targetCopy = { ...loc.node };
  const split = (edge === 'left' || edge === 'top')
    ? { dir, ratio: 50, a: dragged, b: targetCopy }
    : { dir, ratio: 50, a: targetCopy, b: dragged };
  if (!loc.parent) return split;
  loc.parent[loc.key] = split;
  return root;
}
function swapLeaves(root, nameA, nameB) {
  const la = locateNode(root, n => n.panel === nameA);
  const lb = locateNode(root, n => n.panel === nameB);
  if (la && lb) { la.node.panel = nameB; lb.node.panel = nameA; }
  return root;
}
function computeRects(node, rect, out) {
  if (node.panel) { out[node.panel] = rect; return; }
  if (node.dir === 'row') {
    const wA = rect.w * node.ratio / 100;
    computeRects(node.a, { x: rect.x, y: rect.y, w: wA, h: rect.h }, out);
    computeRects(node.b, { x: rect.x + wA, y: rect.y, w: rect.w - wA, h: rect.h }, out);
    customSplitters.push({ node, axis: 'x', rect: { x: rect.x + wA - 0.5, y: rect.y, w: 1, h: rect.h }, parentRect: rect });
  } else {
    const hA = rect.h * node.ratio / 100;
    computeRects(node.a, { x: rect.x, y: rect.y, w: rect.w, h: hA }, out);
    computeRects(node.b, { x: rect.x, y: rect.y + hA, w: rect.w, h: rect.h - hA }, out);
    customSplitters.push({ node, axis: 'y', rect: { x: rect.x, y: rect.y + hA - 0.5, w: rect.w, h: 1 }, parentRect: rect });
  }
}
function applyRectStyle(el, rect) {
  el.style.left = rect.x + '%'; el.style.top = rect.y + '%';
  el.style.width = rect.w + '%'; el.style.height = rect.h + '%';
}
function renderCustom() {
  if ($('#main').dataset.layout !== 'custom' || !customTree) return;
  const out = {};
  customSplitters = [];
  computeRects(customTree, { x: 0, y: 0, w: 100, h: 100 }, out);
  for (const key of ['instr', 'term', 'code']) if (out[key]) applyRectStyle(PANEL_EL[key], out[key]);
  [$('#splitter-a'), $('#splitter-b')].forEach((el, i) => {
    const s = customSplitters[i];
    if (!s) { el.classList.add('hidden'); return; }
    el.classList.remove('hidden');
    el.classList.toggle('splitter-h', s.axis === 'y');
    applyRectStyle(el, s.rect);
  });
  saveCustomTree();
}

function edgeFromPoint(rect, x, y) {
  const relX = (x - rect.left) / rect.width, relY = (y - rect.top) / rect.height;
  if (relX > 0.25 && relX < 0.75 && relY > 0.25 && relY < 0.75) return 'center';
  const d = { left: relX, right: 1 - relX, top: relY, bottom: 1 - relY };
  return Object.keys(d).reduce((a, b) => (d[a] < d[b] ? a : b));
}
function showDropHint(rect, edge) {
  const hint = $('#drop-hint'), mc = $('#main-content').getBoundingClientRect();
  let x = rect.left - mc.left, y = rect.top - mc.top, w = rect.width, h = rect.height;
  if (edge === 'left') w /= 2;
  else if (edge === 'right') { x += rect.width / 2; w /= 2; }
  else if (edge === 'top') h /= 2;
  else if (edge === 'bottom') { y += rect.height / 2; h /= 2; }
  Object.assign(hint.style, { left: x + 'px', top: y + 'px', width: w + 'px', height: h + 'px', display: 'block' });
}
function hideDropHint() { $('#drop-hint').style.display = 'none'; }

function startDockDrag(panelName) {
  document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = 'none');
  document.body.style.cursor = 'grabbing';
  let target = null, edge = null;
  const move = mv => {
    target = null; edge = null;
    for (const key of ['instr', 'term', 'code']) {
      if (key === panelName) continue;
      const r = PANEL_EL[key].getBoundingClientRect();
      if (mv.clientX >= r.left && mv.clientX <= r.right && mv.clientY >= r.top && mv.clientY <= r.bottom) {
        target = key; edge = edgeFromPoint(r, mv.clientX, mv.clientY);
        showDropHint(r, edge);
        break;
      }
    }
    if (!target) hideDropHint();
  };
  const up = () => {
    document.removeEventListener('pointermove', move);
    document.removeEventListener('pointerup', up);
    document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = '');
    document.body.style.cursor = '';
    hideDropHint();
    if (target && target !== panelName) {
      if (edge === 'center') customTree = swapLeaves(customTree, panelName, target);
      else { customTree = removeLeaf(customTree, panelName); customTree = insertLeaf(customTree, target, panelName, edge); }
      renderCustom();
      setMode(state.mode);
      requestAnimationFrame(() => { if (fit) try { fit.fit(); } catch { /* hidden */ } });
    }
  };
  document.addEventListener('pointermove', move);
  document.addEventListener('pointerup', up);
}
for (const key of ['instr', 'term', 'code']) {
  PANEL_EL[key].querySelector('.cpanel-head').onpointerdown = ev => {
    if ($('#main').dataset.layout !== 'custom') return;
    ev.preventDefault();
    startDockDrag(key);
  };
}

// ------------------------------------------------------------------ splitters & panel layouts
function makeSplitter(el, varKey) {
  el.onpointerdown = ev => {
    el.setPointerCapture(ev.pointerId); el.classList.add('dragging');
    document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = 'none');
  };
  el.onpointermove = ev => {
    if (!el.classList.contains('dragging')) return;
    const layout = $('#main').dataset.layout;
    const r = $('#main-content').getBoundingClientRect();
    if (layout === 'custom') {
      const s = customSplitters[varKey === 'a' ? 0 : 1];
      if (!s) return;
      const pr = s.parentRect;
      const ratio = s.axis === 'x'
        ? 100 * ((100 * (ev.clientX - r.left) / r.width) - pr.x) / pr.w
        : 100 * ((100 * (ev.clientY - r.top) / r.height) - pr.y) / pr.h;
      s.node.ratio = Math.min(85, Math.max(15, ratio));
      renderCustom();
      return;
    }
    const axis = varKey === 'a' ? 'x' : (layout === 'sidebyside' ? 'x' : 'y');
    const pct = axis === 'x'
      ? Math.min(80, Math.max(15, 100 * (ev.clientX - r.left) / r.width))
      : Math.min(80, Math.max(15, 100 * (ev.clientY - r.top) / r.height));
    $('#main-content').style.setProperty(`--split-${varKey}`, pct + '%');
  };
  el.onpointerup = () => {
    el.classList.remove('dragging');
    document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = '');
    const layout = $('#main').dataset.layout;
    if (layout !== 'custom') {
      try { localStorage.setItem(`split_${layout}_${varKey}`, $('#main-content').style.getPropertyValue(`--split-${varKey}`)); } catch { /* private mode */ }
    }
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
  if (!LAYOUT_DEFAULTS[name] && name !== 'custom') name = 'default';
  const main = $('#main'), mc = $('#main-content');
  main.dataset.layout = name;
  document.querySelectorAll('.layout-menu-item').forEach(b => b.classList.toggle('current', b.dataset.layout === name));
  if (name === 'custom') {
    if (!customTree) loadCustomTree();
    renderCustom();
  } else {
    for (const el of [PANEL_EL.instr, PANEL_EL.term, PANEL_EL.code, $('#splitter-a'), $('#splitter-b')]) {
      el.style.left = el.style.top = el.style.width = el.style.height = '';
    }
    $('#splitter-a').classList.remove('hidden', 'splitter-h');
    $('#splitter-b').classList.toggle('hidden', name === 'default');
    $('#splitter-b').classList.toggle('splitter-h', name === 'leftstack' || name === 'vscodeleft');
    const d = LAYOUT_DEFAULTS[name];
    let a = d.a, b = d.b;
    try {
      a = localStorage.getItem(`split_${name}_a`) || d.a;
      if (d.b) b = localStorage.getItem(`split_${name}_b`) || d.b;
    } catch { /* private mode */ }
    mc.style.setProperty('--split-a', a);
    if (b) mc.style.setProperty('--split-b', b);
  }
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

// ------------------------------------------------------------------ home page (track picker)
const TRACK_LABELS = { minimal: 'Minimal', intermediate: 'Intermediate', complete: 'Complete' };
function updateTrackBadge() {
  const badge = $('#track-badge');
  if (state.exam) {
    const e = Exams.entry(state.exam);
    badge.textContent = Exams.t('badge') + (e ? e.title : state.exam);
    badge.classList.remove('hidden');
    return;
  }
  if (state.theory) {
    const c = Theory.collection(state.theory);
    badge.textContent = Theory.t('badge') + (c ? c.title : state.theory);
    badge.classList.remove('hidden');
    return;
  }
  if (state.introCategory === 'all') { badge.textContent = 'Intro: Full set'; badge.classList.remove('hidden'); return; }
  if (state.introCategory) {
    const t = state.index.find(x => x.id === state.introCategory);
    badge.textContent = 'Intro: ' + (t ? t.title : state.introCategory);
    badge.classList.remove('hidden');
    return;
  }
  if (state.track === 'full') { badge.classList.add('hidden'); return; }
  badge.textContent = TRACK_LABELS[state.track];
  badge.classList.remove('hidden');
}
function renderHomePage() {
  const stats = { full: [0, 0], minimal: [0, 0], intermediate: [0, 0] }; // [done, total]
  let introDone = 0, introTotal = 0;
  for (const e of state.flat) {
    if (e.tier === 0) { introTotal++; if (e.status === 'pass') introDone++; continue; }
    stats.full[1]++; if (e.status === 'pass') stats.full[0]++;
    if (e.tier <= 1) { stats.minimal[1]++; if (e.status === 'pass') stats.minimal[0]++; }
    if (e.tier <= 2) { stats.intermediate[1]++; if (e.status === 'pass') stats.intermediate[0]++; }
  }
  for (const el of document.querySelectorAll('#track-grid .track-card-count')) {
    const [done, total] = stats[el.dataset.count];
    el.textContent = `${done}/${total} exercises`;
  }
  $('[data-count="intro-all"]').textContent = `${introDone}/${introTotal} exercises`;
  for (const el of document.querySelectorAll('#track-grid .track-card')) el.classList.toggle('current', !state.theory && !state.introCategory && el.dataset.track === state.track);
  $('#intro-all-card').classList.toggle('current', state.introCategory === 'all');
  renderIntroGrid();
  Theory.renderHomeGrid();
  Exams.renderHomeGrid();
  renderHomeNav();
  Exams.refresh();
}

// Left navigation of the home page. It is the exercise sidebar (same markup and classes) as a tree:
//   Tracks     -> track -> category -> exercise
//   Introduction -> category -> exercise
//   Quizzes    -> collection -> group -> question
// Every entry that has contents shows an arrow (click it to open/close) and its name (click it to go there).
const HOME_SECTIONS = [['tracks', 'home-sec-tracks', 'home-grp-exercises'], ['intro', 'home-sec-intro', 'home-grp-exercises'], ['quizzes', 'theory-quizzes-title', 'theory-home-title'], ['exams', 'theory-exams-title', 'theory-home-title']];
const lsGet = (k, d) => { try { return JSON.parse(localStorage.getItem(k)) || d; } catch { return d; } };
const lsSet = (k, v) => { try { localStorage.setItem(k, JSON.stringify(v)); } catch { /* private mode */ } };
function saveHomeNavState() {   // after a user action; ignored while a search forces everything open
  if ($('#home-search').value.trim()) return;
  const all = [...document.querySelectorAll('#home-topics details')];
  lsSet('homeNavClosed', all.filter(d => d.dataset.sec && !d.open).map(d => d.dataset.sec));
  lsSet('homeNavOpen', all.filter(d => d.dataset.key && d.open).map(d => d.dataset.key));
}
function homeTree() {
  const dotOf = (done, total) => total && done === total ? 'pass' : done ? 'attempted' : 'new';
  const sum = (kids, f) => kids.reduce((n, k) => n + f(k), 0);
  const group = (key, label, search, go, current, kids, extra = {}) => {
    const done = sum(kids, k => k.done), total = sum(kids, k => k.total);
    return { key, label, search: search.toLowerCase(), go, current, kids, done, total, ...extra };
  };
  const leaf = (label, search, go, current, status, idTag) =>
    ({ label, search: search.toLowerCase(), go, current, status, idTag, done: status === 'pass' ? 1 : 0, total: 1 });
  const exCur = e => !state.theory && state.current && state.current.id === e.id;
  const trackTitle = k => document.querySelector(`#track-grid [data-track="${k}"] .track-card-title`).textContent;
  const tracks = ['minimal', 'intermediate', 'full'].map(k => {
    const here = !state.theory && !state.introCategory && state.track === k;
    const cats = state.index.map(t => ({ t, ex: t.exercises.filter(e => e.tier !== 0 && (k === 'full' || e.tier <= TRACK_MAX[k])) })).filter(x => x.ex.length)
      .map(({ t, ex }) => group(`track:${k}:${t.id}`, `${t.id} · ${t.title}`, `${t.id} ${t.title}`, `trackcat:${k}:${t.id}`, false,
        ex.map(e => leaf(e.title, `${e.id} ${e.title} ${e.cmds || ''}`, `trackex:${k}:${e.id}`, here && exCur(e), e.status, e.id))));
    return group(`track:${k}`, trackTitle(k), trackTitle(k), `track:${k}`, here, cats);
  });
  const introCats = state.index.filter(t => t.id !== '18' && t.id !== '19' && t.exercises.some(e => e.tier === 0)).map(t =>
    group(`intro:${t.id}`, t.title, `${t.id} ${t.title}`, `intro:${t.id}`, !state.theory && state.introCategory === t.id,
      t.exercises.filter(e => e.tier === 0).map(e => leaf(e.title, `${e.id} ${e.title} ${e.cmds || ''}`, `introex:${t.id}:${e.id}`,
        !state.theory && state.introCategory === t.id && exCur(e), e.status, e.id)), { idTag: t.id }));
  const allDone = sum(introCats, c => c.done), allTotal = sum(introCats, c => c.total);
  const introAll = leaf($('#intro-all-card .track-card-title').textContent, 'full introduction set', 'intro:all',
    !state.theory && state.introCategory === 'all', dotOf(allDone, allTotal));
  introAll.done = allDone; introAll.total = allTotal;
  const cur = Theory.current();
  const quizzes = Theory.list().map(c => group(`quiz:${c.id}`, c.title, c.title, `quiz:${c.id}`, state.theory === c.id,
    c.groups.map(g => group(`quizgroup:${c.id}:${g.id}`, g.title, g.title, `quizgroup:${c.id}:${g.id}`, false,
      g.questions.map(q => leaf(q.title, q.title, `quizq:${c.id}:${q.id}`, !!cur && cur.cid === c.id && cur.qid === q.id, q.status))))));
  const examTiers = ['easy', 'medium', 'hard'].filter(t => Exams.list().some(e => e.tier === t)).map(t => {
    const lab = Exams.tierLabel(t);
    return group(`examtier:${t}`, lab, lab, `examtier:${t}`, false,
      Exams.list().filter(e => e.tier === t).map(e => leaf(e.title, `${e.title} ${lab}`, `exam:${e.id}`, state.exam === e.id, Exams.statusOf(e))));
  });
  return { tracks, intro: [introAll, ...introCats], quizzes, exams: examTiers };
}
function renderHomeNav() {
  const nav = $('#home-topics');
  if (!nav || !state.index) return;
  const q = $('#home-search').value.trim().toLowerCase();
  const hidePassed = $('#home-hide-passed').checked;
  const closed = new Set(lsGet('homeNavClosed', [])), openKeys = new Set(lsGet('homeNavOpen', []));
  const tree = homeTree();
  // a node is shown when it matches, or when one of its descendants does (an ancestor match shows all its contents)
  const node = (n, all, depth) => {
    const own = !q || all || n.search.includes(q);
    if (!n.kids) {
      if (!own || (hidePassed && n.status === 'pass')) return '';
      const st = n.status || 'new';
      return `<a class="ex-item d${depth}${n.current ? ' current' : ''}" href="#" data-go="${esc(n.go)}" title="${esc(n.label)}">
        <span class="dot ${st}">${STATUS[st].dot}</span>${n.idTag ? `<span class="ex-id">${esc(n.idTag)}</span>` : ''}<span class="ex-name">${esc(n.label)}</span>
        ${n.total > 1 ? `<span class="t-count">${n.done}/${n.total}</span>` : ''}</a>`;
    }
    const kids = n.kids.map(k => node(k, q ? own : false, depth + 1)).join('');
    if ((q && !own && !kids) || (hidePassed && !kids)) return '';   // nothing left to show under it
    return `<details class="topic entry d${depth}" data-key="${esc(n.key)}"${q || openKeys.has(n.key) ? ' open' : ''}>
      <summary class="${n.current ? 'current' : ''}" data-go="${esc(n.go)}" title="${esc(n.label)}"><span class="t-arrow" title="Show / hide the contents"></span>
        <span class="t-name">${esc(n.label)}</span><span class="t-count">${n.done}/${n.total}</span></summary>
      <div class="t-bar"><div style="width:${n.total ? 100 * n.done / n.total : 0}%"></div></div>${kids}</details>`;
  };
  let html = '', lastGroup = null;
  for (const [sec, headId, grp] of HOME_SECTIONS) {
    const items = tree[sec].map(n => node(n, false, 1)).join('');
    if (!items) continue;
    if (grp !== lastGroup) { html += `<button class="home-group-label" data-scroll="${grp}">${esc($('#' + grp).textContent)}</button>`; lastGroup = grp; }
    // section count: the 17 intro categories / the 13 quizzes (tracks contain each other, so they show none)
    const counted = sec === 'intro' ? tree[sec].filter(n => n.kids) : tree[sec];
    const done = sec === 'tracks' ? 0 : sum2(counted, 'done'), total = sec === 'tracks' ? 0 : sum2(counted, 'total');
    html += `<details class="topic" data-sec="${sec}" data-scroll="${headId}"${q || !closed.has(sec) ? ' open' : ''}>
      <summary><span class="t-name">${esc($('#' + headId).textContent)}</span>${sec === 'tracks' ? '' : `<span class="t-count">${done}/${total}</span>`}</summary>
      ${sec === 'tracks' ? '' : `<div class="t-bar"><div style="width:${total ? 100 * done / total : 0}%"></div></div>`}${items}</details>`;
  }
  nav.innerHTML = html || '<p class="home-intro" style="margin:16px">Nothing matches.</p>';
  syncHomeNav.last = null;
  syncHomeNav();
}
const sum2 = (arr, f) => arr.reduce((n, k) => n + k[f], 0);
function syncHomeNav() {
  const body = $('#home-body'), nav = $('#home-topics');
  if (!body || !nav) return;
  const at = id => $('#' + id).offsetTop;
  const y = body.scrollTop + 120;
  let cur = null;
  for (const [sec, headId] of HOME_SECTIONS) if (at(headId) <= y) cur = sec;
  const g = at('theory-home-title') <= y ? 'theory-home-title' : 'home-grp-exercises';
  nav.querySelectorAll('.home-group-label').forEach(b => b.classList.toggle('active', b.dataset.scroll === g));
  nav.querySelectorAll('details[data-sec]').forEach(d => d.classList.toggle('active', d.dataset.sec === cur));
  // keep the highlighted section visible in the sidebar as the page scrolls (only when it changes)
  const key = g + ':' + cur;
  if (key !== syncHomeNav.last) {
    syncHomeNav.last = key;
    const el = nav.querySelector('details.active > summary') || nav.querySelector('.home-group-label.active');
    if (el) el.scrollIntoView({ block: 'nearest' });
  }
}
// what clicking an entry / row does: the same as picking it on its card, or opening that exact exercise / question
function homeGo(go) {
  const [act, a, b] = go.split(':');
  const first = list => list.find(e => e.status !== 'pass') || list[0];
  const topic = id => state.index.find(t => t.id === id);
  if (act === 'track') selectTrack(a);
  else if (act === 'trackcat') selectTrack(a, (first(topic(b).exercises.filter(e => e.tier !== 0 && (a === 'full' || e.tier <= TRACK_MAX[a]))) || {}).id);
  else if (act === 'trackex') selectTrack(a, b);
  else if (act === 'intro') selectIntroCategory(a);
  else if (act === 'introex') selectIntroCategory(a, b);
  else if (act === 'quiz') Theory.go(a);
  else if (act === 'quizgroup') {
    const c = Theory.collection(a), g = c.groups.find(x => x.id === b);
    Theory.go(a, (g.questions.find(x => x.status !== 'pass') || g.questions[0]).id);
  } else if (act === 'quizq') Theory.go(a, b);
  else if (act === 'exam') Exams.go(a);
  else if (act === 'examtier') {
    const es = Exams.list().filter(e => e.tier === a);
    const next = es.find(e => Exams.statusOf(e) !== 'pass') || es[0];
    if (next) Exams.go(next.id);
  }
}
$('#home-body').addEventListener('scroll', syncHomeNav);
$('#home-search').oninput = renderHomeNav;
$('#home-hide-passed').onchange = renderHomeNav;
$('#home-expand-btn').onclick = () => { document.querySelectorAll('#home-topics details').forEach(d => { d.open = true; }); saveHomeNavState(); };
$('#home-collapse-btn').onclick = () => { document.querySelectorAll('#home-topics details').forEach(d => { d.open = false; }); saveHomeNavState(); };
$('#home-topics').addEventListener('click', ev => {
  const row = ev.target.closest('.ex-item');
  if (row) { ev.preventDefault(); homeGo(row.dataset.go); return; }
  const head = ev.target.closest('summary, .home-group-label');
  if (!head) return;
  if (head.tagName === 'SUMMARY') {
    ev.preventDefault();                       // we decide ourselves between "open/close" and "go there"
    const d = head.parentElement;
    if (d.classList.contains('entry') && !ev.target.closest('.t-arrow')) { homeGo(head.dataset.go); return; }
    const opening = !d.open;
    d.open = opening;
    saveHomeNavState();
    // a section that opens also comes into view; folding it only folds the list
    const target = d.dataset.scroll && $('#' + d.dataset.scroll);
    if (opening && target) target.scrollIntoView({ block: 'start' });
    return;
  }
  const target = $('#' + head.dataset.scroll);
  if (target) target.scrollIntoView({ block: 'start' });
});
$('#home-nav').addEventListener('click', ev => {
  const pick = ev.target.closest('.hn-item');
  if (pick) {
    const sel = pick.dataset.pick, key = pick.dataset.key;
    const card = sel === '#intro-all-card' ? $(sel)
      : [...document.querySelectorAll(sel)].find(c => (c.dataset.track || c.dataset.introTopic || c.dataset.theory) === key);
    if (card) card.click();
    return;
  }
  const head = ev.target.closest('summary, .hn-group');
  if (!head) return;
  const owner = head.closest('[data-scroll]') || head;
  const target = $('#' + owner.dataset.scroll);
  // opening a section also brings it into view; closing it only folds the list
  if (head.tagName === 'SUMMARY' && owner.open) return;
  if (target) target.scrollIntoView({ block: 'start' });
});
function renderIntroGrid() {
  const grid = $('#intro-grid');
  grid.innerHTML = state.index.filter(t => t.id !== '18' && t.id !== '19').map(t => {
    const exs = t.exercises.filter(e => e.tier === 0);
    const done = exs.filter(e => e.status === 'pass').length;
    const cur = state.introCategory === t.id;
    return `<button class="track-card${cur ? ' current' : ''}" data-intro-topic="${esc(t.id)}">
      <div class="track-card-title">${esc(t.id)} · ${esc(t.title)}</div>
      <div class="track-card-count">${done}/${exs.length} exercises</div>
    </button>`;
  }).join('');
}
// `exId` (optional) opens that exercise instead of the first one not passed yet
function selectIntroCategory(id, exId) {
  state.theory = null;
  state.exam = null;
  state.introCategory = id;
  try { localStorage.setItem('introCategory', id); } catch { /* private mode */ }
  updateTrackBadge();
  renderSidebar();
  const pool = visibleFlat();
  const next = (exId && pool.find(e => e.id === exId)) || pool.find(e => e.status !== 'pass') || pool[0];
  location.hash = next ? `#/ex/${next.id}` : '#/home';
}
function selectTrack(track, exId) {
  state.track = track;
  state.theory = null;
  state.exam = null;
  state.introCategory = null;
  try { localStorage.setItem('track', state.track); localStorage.removeItem('introCategory'); } catch { /* private mode */ }
  updateTrackBadge();
  renderSidebar();
  const pool = visibleFlat();
  const next = (exId && pool.find(e => e.id === exId)) || pool.find(e => e.status !== 'pass') || pool[0];
  location.hash = next ? `#/ex/${next.id}` : '#/home';
}
$('#track-grid').addEventListener('click', ev => {
  const card = ev.target.closest('.track-card');
  if (card) selectTrack(card.dataset.track);
});
$('#intro-grid').addEventListener('click', ev => {
  const card = ev.target.closest('[data-intro-topic]');
  if (!card) return;
  selectIntroCategory(card.dataset.introTopic);
});
$('#intro-all-card').onclick = () => selectIntroCategory('all');
$('#track-badge').onclick = () => { location.hash = '#/home'; };
$('#home-back').onclick = ev => {
  ev.preventDefault();
  if (state.lastExerciseId) location.hash = `#/ex/${state.lastExerciseId}`;
  else if (history.length > 1) history.back();
  else location.hash = '#/ex/0101';
};

// ------------------------------------------------------------------ routing & start
function showReferencePage(show) {
  document.querySelector('.layout').classList.toggle('hidden', show);
  $('#reference-page').classList.toggle('hidden', !show);
}
function showHomePage(show) {
  document.querySelector('.layout').classList.toggle('hidden', show);
  $('#home-page').classList.toggle('hidden', !show);
  // the home page covers the top bar: carry the settings button over to its own bar while it is shown
  const picker = $('#settings-picker');
  (show ? $('#home-head-slot') : document.querySelector('.topbar')).appendChild(picker);
  if (!show) { $('#settings-menu').classList.add('hidden'); $('#settings-btn').setAttribute('aria-expanded', 'false'); }
  if (show) renderHomePage();
}
function route() {
  if (!Exams.allowRoute(location.hash)) return;   // leaving a running exam attempt asks first
  const refCmd = location.hash.match(/^#\/reference\/cmd\/([^/]+)$/);
  const refTopic = location.hash.match(/^#\/reference\/topic\/([^/]+)$/);
  if (location.hash === '#/reference' || refCmd || refTopic) {
    showHomePage(false);
    showReferencePage(true);
    if (!refTopics) buildReferenceIndex();
    if (refCmd) refSel = { type: 'cmd', key: decodeURIComponent(refCmd[1]) };
    else if (refTopic) refSel = { type: 'topic', id: decodeURIComponent(refTopic[1]) };
    else { refSel = { type: 'all' }; $('#reference-search').value = ''; }
    renderReference();
    return;
  }
  showReferencePage(false);
  if (location.hash === '#/home') { showHomePage(true); return; }
  showHomePage(false);
  const exm = location.hash.match(/^#\/exam\/([\w-]+)(?:\/attempt\/(\d+))?$/);
  if (exm) {
    if (!$('#theory-main').classList.contains('hidden')) Theory.hide();
    return Exams.open(exm[1], exm[2]);
  }
  if (state.exam || Exams.visible()) { state.exam = null; Exams.hide(); updateTrackBadge(); renderSidebar(); }
  const th = location.hash.match(/^#\/theory\/([\w-]+)(?:\/([\w-]*))?$/);
  if (th) return Theory.open(th[1], th[2]);
  // leaving the quiz view: back to the exercise panels. Checked on the panel itself, since picking a
  // track or intro category on the home page clears state.theory without hiding the quiz.
  if (state.theory || !$('#theory-main').classList.contains('hidden')) {
    state.theory = null;
    Theory.hide();
    updateTrackBadge();
    renderSidebar();
  }
  const m = location.hash.match(/^#\/ex\/(\d{4})$/);
  if (m) { state.lastExerciseId = m[1]; return openExercise(m[1]); }
  const pool = visibleFlat();
  const next = pool.find(e => e.status !== 'pass') || pool[0];
  if (next) location.replace(`#/ex/${next.id}`);
}
window.addEventListener('hashchange', route);

// ------------------------------------------------------------------ sidebar collapse & resize
// The same full-height strip both collapses the sidebar (a plain click) and resizes it
// (dragging it sideways) — a small pointer-movement threshold tells the two apart.
function setupSidebarHandle({ btn, sidebar, layoutEl, widthKey, collapsedKey }) {
  const MIN = 180, MAX = 480, DEFAULT_W = 290;
  let savedWidth = DEFAULT_W;
  try { savedWidth = parseInt(localStorage.getItem(widthKey), 10) || DEFAULT_W; } catch { /* private mode */ }
  sidebar.style.width = savedWidth + 'px';

  function setCollapsed(collapsed) {
    layoutEl.classList.toggle('sidebar-collapsed', collapsed);
    if (!collapsed) sidebar.style.width = savedWidth + 'px';
    btn.title = collapsed ? 'Expand sidebar' : 'Collapse sidebar';
    try { localStorage.setItem(collapsedKey, collapsed ? '1' : ''); } catch { /* private mode */ }
  }
  try { if (localStorage.getItem(collapsedKey)) setCollapsed(true); } catch { /* private mode */ }

  let startX = 0, startW = 0, dragging = false;
  btn.onpointerdown = ev => {
    startX = ev.clientX; startW = sidebar.getBoundingClientRect().width; dragging = false;
    btn.setPointerCapture(ev.pointerId);
  };
  btn.onpointermove = ev => {
    if (!btn.hasPointerCapture(ev.pointerId)) return;
    const dx = ev.clientX - startX;
    if (!dragging && Math.abs(dx) > 4) {
      dragging = true;
      btn.classList.add('resizing');
      sidebar.classList.add('no-transition');
      document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = 'none');
    }
    if (dragging && !layoutEl.classList.contains('sidebar-collapsed')) {
      savedWidth = Math.min(MAX, Math.max(MIN, startW + dx));
      sidebar.style.width = savedWidth + 'px';
    }
  };
  btn.onpointerup = () => {
    document.querySelectorAll('iframe').forEach(f => f.style.pointerEvents = '');
    sidebar.classList.remove('no-transition');
    if (dragging) {
      btn.classList.remove('resizing');
      try { localStorage.setItem(widthKey, String(Math.round(savedWidth))); } catch { /* private mode */ }
    } else {
      setCollapsed(!layoutEl.classList.contains('sidebar-collapsed'));
    }
    dragging = false;
  };
}
setupSidebarHandle({ btn: $('#sidebar-toggle'), sidebar: $('#sidebar'), layoutEl: document.querySelector('.layout'), widthKey: 'sidebarWidth', collapsedKey: 'sidebarCollapsed' });
setupSidebarHandle({ btn: $('#home-sidebar-toggle'), sidebar: $('#home-nav'), layoutEl: $('#home-layout'), widthKey: 'homeSidebarWidth', collapsedKey: 'homeSidebarCollapsed' });

(async () => {
  // theory.js is the last script on the page: wait until every script has run
  if (document.readyState === 'loading') await new Promise(r => document.addEventListener('DOMContentLoaded', r));
  applyTheme(currentTheme(), false);
  updateTrackBadge();
  await loadIndex();
  updateTrackBadge(); // re-run now state.index is populated, for the Intro category title lookup
  await route();
  let mode = 'term';
  try { mode = localStorage.getItem('mode') || 'term'; } catch { /* private mode */ }
  state.mode = mode;
  let layout = 'default';
  try { layout = localStorage.getItem('workLayout') || 'default'; } catch { /* private mode */ }
  applyLayout(layout, { persist: false });
})();
