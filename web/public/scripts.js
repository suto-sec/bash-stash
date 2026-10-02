// bash stash — Scripts: one script built up in steps. Every step adds one requirement and is validated by its own check; the file
// you edit (.progress/scripts/<id>/<name>.sh) keeps growing from step to step. A script is done when all its steps have passed.
// Statements, checks and reference solutions: scripts/<id>_<slug>/ and solutions/scripts/ (built by tools/build_scripts.js).
// The attempt itself reuses the exercise screen (statement, terminal, VS Code, Check, Info, Show solution).
'use strict';
const Scripts = (() => {
  let index = [];
  let cur = null;   // { id, d (detail), step }
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const api = (p, opt) => fetch(`/api/scripts${p}`, opt);
  const num = id => id.slice(1);

  async function load() {
    try { index = await (await api('')).json(); } catch { index = []; }
    if (!Array.isArray(index)) index = [];
  }
  // ---------------------------------------------------------------- setting (⚙ menu): one step at a time, or every part at once
  const isFull = () => { try { return localStorage.getItem('scMode') === 'full'; } catch { return false; } };
  Seg.on('scmode', v => {
    try { localStorage.setItem('scMode', v === 'full' ? 'full' : 'steps'); } catch { /* private mode */ }
    Seg.set('scmode', isFull() ? 'full' : 'steps');
    if (cur && state.script) { cur.step = isFull() ? cur.d.steps.length : cur.d.current; fillStatement(); renderSidebar(); }
  });
  Seg.set('scmode', isFull() ? 'full' : 'steps');
  const list = () => index;
  const entry = id => index.find(e => e.id === id);
  const statusOf = e => e.status;
  async function refresh() { await load(); renderHomeGrid(); }
  // ---------------------------------------------------------------- grouping and ordering (dropdowns, remembered)
  // "Group by" makes the sections, "Order by" + the direction sorts the scripts inside them; they may be the same property (then the direction
  // also turns the sections around: descending difficulty shows the 5-star section first).
  const MODES = { stars: 'Difficulty', topic: 'Topic', steps: 'Number of steps', progress: 'Progress' };
  const getMode = () => { try { const m = localStorage.getItem('scriptGroup'); return MODES[m] ? m : 'stars'; } catch { return 'stars'; } };
  const ORDERS = { num: 'Number', title: 'Title', stars: 'Difficulty (stars)', steps: 'Number of steps', progress: 'Progress', topic: 'Topic' };
  const getOrder = () => { try { const m = localStorage.getItem('scriptOrder'); return ORDERS[m] ? m : 'num'; } catch { return 'num'; } };
  const getDir = () => { try { return localStorage.getItem('scriptDir') === 'desc' ? 'desc' : 'asc'; } catch { return 'asc'; } };
  const progressOf = e => (e.steps.length ? e.passed.length / e.steps.length : 0);
  const ORDER_KEY = { num: e => Number(num(e.id)), title: e => e.title.toLowerCase(), stars: e => e.level, steps: e => e.steps.length, progress: progressOf, topic: e => (e.tags[0] || '') };
  function sorted(items) {
    const key = ORDER_KEY[getOrder()], sign = getDir() === 'desc' ? -1 : 1;
    return [...items].sort((a, b) => { const x = key(a), y = key(b); return (x < y ? -1 : x > y ? 1 : 0) * sign || Number(num(a.id)) - Number(num(b.id)); });
  }
  const stars = n => '★'.repeat(n) + '☆'.repeat(5 - n);
  function groups() {       // [{ key, label, items }], items are index entries; "topic" lists a script under each of its tags
    const mode = getMode();
    const by = (keys, labelOf, pick) => keys.map(k => ({ key: String(k), label: labelOf(k), items: sorted(index.filter(e => pick(e, k))) })).filter(g => g.items.length);
    const same = mode === getOrder() && getDir() === 'desc';                // the same property, descending: the sections turn around too
    const sections = list => same ? list.reverse() : list;
    if (mode === 'stars') return sections(by([1, 2, 3, 4, 5], stars, (e, k) => e.level === k));
    if (mode === 'topic') return sections(by([...new Set(index.flatMap(e => e.tags))].sort(), t => t[0].toUpperCase() + t.slice(1), (e, k) => e.tags.includes(k)));
    if (mode === 'steps') return sections(by(['short', 'medium', 'long'], k => ({ short: 'Short (2-3 steps)', medium: 'Medium (4-5 steps)', long: 'Long (6+ steps)' })[k],
      (e, k) => (e.steps.length <= 3 ? 'short' : e.steps.length <= 5 ? 'medium' : 'long') === k));
    return sections(by(['inprogress', 'new', 'pass'], k => ({ inprogress: 'In progress', new: 'Not started', pass: 'Done' })[k],
      (e, k) => (e.status === 'attempted' ? 'inprogress' : e.status) === k));
  }
  const displayOrder = () => [...new Map(groups().flatMap(g => g.items).map(e => [e.id, e])).values()];     // every script once, as the lists show them
  const doneCount = () => index.filter(e => e.status === 'pass').length;
  function applyMode() {    // after the dropdown changed: every view that lists the scripts
    renderHomeGrid();
    if (typeof renderHomeNav === 'function') renderHomeNav();
    if (cur && state.script) renderSidebar();
  }
  const VIEW_KEYS = { group: 'scriptGroup', order: 'scriptOrder', dir: 'scriptDir' };
  const VIEW_DEFAULT = { group: 'stars', order: 'num', dir: 'asc' };
  function setView(part) {                    // part: { group?, order?, dir? } from the home dropdowns or the sidebar panel; no part = back to the defaults
    const v = part || VIEW_DEFAULT;
    for (const k of Object.keys(v)) { try { localStorage.setItem(VIEW_KEYS[k], v[k]); } catch { /* private mode */ } }
    applyMode();
  }
  for (const [id, k] of [['scripts-group', 'group'], ['scripts-order', 'order'], ['scripts-dir', 'dir']]) $('#' + id).onchange = ev => setView({ [k]: ev.target.value });
  $('#scripts-reset').onclick = () => setView();
  // the same three choices (and the reset) at the top of the sidebar while a script is open: no need to go back to the home page
  const DIRS = { asc: 'Increasing', desc: 'Decreasing' };
  const sideView = () => {
    let box = $('#sc-view');
    if (!box) {
      box = document.createElement('details');
      box.id = 'sc-view'; box.className = 'sc-view';
      try { box.open = localStorage.getItem('scViewOpen') === '1'; } catch { /* private mode */ }
      box.addEventListener('toggle', () => { try { localStorage.setItem('scViewOpen', box.open ? '1' : '0'); } catch { /* private mode */ } });
      box.addEventListener('change', ev => { const k = ev.target.dataset.k; if (k) setView({ [k]: ev.target.value }); });
      box.addEventListener('click', ev => { if (ev.target.closest('.scv-reset')) setView(); });
      $('#sidebar').insertBefore(box, $('#topics'));
    }
    return box;
  };
  const optionsOf = (map, cur) => Object.entries(map).map(([v, t]) => `<option value="${v}"${v === cur ? ' selected' : ''}>${esc(t)}</option>`).join('');
  function renderSideView() {
    const box = sideView(), g = getMode(), o = getOrder(), d = getDir();
    box.innerHTML = `<summary><span class="scv-title">View</span><span class="scv-now"><span>Group by: <b>${esc(MODES[g])}</b></span><span>Order by: <b>${esc(ORDERS[o])}</b></span><span>Direction: <b>${DIRS[d]}</b></span></span></summary>
      <div class="scv-body">
        <label>Group by <select data-k="group">${optionsOf(MODES, g)}</select></label>
        <label>Order by <select data-k="order">${optionsOf(ORDERS, o)}</select></label>
        <label>Direction <select data-k="dir">${optionsOf(DIRS, d)}</select></label>
        <button type="button" class="small scv-reset" title="Group by difficulty, order by number, increasing">Reset</button>
      </div>`;
  }
  const go = (id, step) => { location.hash = `#/script/${id}${step ? '/' + step : ''}`; };

  // ---------------------------------------------------------------- home grid
  function renderHomeGrid() {
    const grid = $('#scripts-grid');
    if (!index.length) { grid.innerHTML = '<p class="home-intro">No scripts built yet (run <code>node tools/build_scripts.js</code>).</p>'; return; }
    $('#scripts-group').value = getMode(); $('#scripts-order').value = getOrder(); $('#scripts-dir').value = getDir();
    grid.innerHTML = groups().map(g => {
      const es = g.items;
      const card = e => `<button class="track-card exam-card${state.script === e.id ? ' current' : ''}" data-script="${esc(e.id)}">
        <div class="track-card-title">${num(e.id)} · ${esc(e.title)}</div>
        <div class="track-card-desc"><span class="stars">${stars(e.level)}</span> · <code>${esc(e.script)}</code> · ${e.steps.length} steps</div>
        <div class="track-card-desc">${e.tags.map(esc).join(' · ')}</div>
        <div class="track-card-count"><span class="${e.status === 'pass' ? 'exam-best good' : ''}">${e.passed.length}/${e.steps.length} steps passed</span></div></button>`;
      return `<h3 class="home-tier-title">${esc(g.label)} <span>${es.filter(e => e.status === 'pass').length}/${es.length} done</span></h3>
        <div class="track-grid exam-grid">${es.map(card).join('')}</div>`;
    }).join('');
  }
  $('#scripts-grid').addEventListener('click', ev => {
    const c = ev.target.closest('[data-script]');
    if (c) { const e = entry(c.dataset.script); go(c.dataset.script, e ? (e.steps.find(s => !e.passed.includes(s.n)) || e.steps[e.steps.length - 1]).n : 1); }
  });

  // ---------------------------------------------------------------- the attempt (statement of the step + terminal + VS Code)
  async function open(id, stepArg) {
    if (!entry(id)) await load();
    const r = await api(`/${id}`);
    if (!r.ok) { location.replace('#/home'); return; }
    const d = await r.json();
    if (!location.hash.startsWith(`#/script/${id}`)) return;           // navigated away while loading
    const step = isFull() ? d.steps.length : d.steps.some(s => s.n === Number(stepArg)) ? Number(stepArg) : d.current;
    const sameScript = cur && cur.id === id && state.script === id;
    cur = { id, d, step };
    state.script = id; state.theory = null; state.exam = null; state.sexam = null;
    state.current = { id, sc: true, title: `${num(id)} · ${d.title}`, level: 0, cmds: d.cmds, status: d.status, topic: d.tags.join(', '),
      dir: d.playDir || d.answer.replace(/\/[^/]*$/, ''), playDir: d.playDir, answer: d.answer, readme: '' };
    document.body.classList.add('script-run');
    $('#exam-main').classList.add('hidden');
    $('#theory-main').classList.add('hidden');
    $('#main').classList.remove('hidden');
    $('#sidebar').classList.add('script-mode');
    fillStatement();
    updateTrackBadge();
    renderSidebar();
    if (!sameScript) {
      state.activeVSCodeFile = null; state.codeFor = null;
      const layout = $('#main').dataset.layout || 'default';
      if (layout !== 'default' || state.mode === 'code') openVSCode();
      if (sock && sock.readyState === 1 && d.playDir) sock.send(JSON.stringify({ t: 'i', d: `cd ${shq(d.playDir)} && clear && ls\r` }));
    }
  }
  function fillStatement() {
    const { d, step } = cur, st = d.steps.find(s => s.n === step);
    $('#ex-topic').textContent = `Scripts · ${d.tags.join(', ')}`;
    $('#ex-title').textContent = `${num(d.id)} · ${d.title}`;
    $('#ex-level').textContent = stars(d.level);
    $('#ex-cmds').textContent = d.cmds;
    const b = $('#ex-status');
    b.className = 'badge ' + d.status; b.textContent = STATUS[d.status].label;
    $('#answer-path').textContent = 'script: ' + d.answer.replace(/^\/home\/alumno\/lab\//, '');
    const full = isFull();
    $('#sc-steps').innerHTML = full ? `<span class="sc-step-title">All ${d.steps.length} parts at once · one check of the finished script</span>` : d.steps.map(s => `<button class="sc-step${s.n === step ? ' active' : ''}${d.passed.includes(s.n) ? ' done' : ''}" data-step="${s.n}" title="${esc(s.title)}">${d.passed.includes(s.n) ? '✓' : ''}${s.n}</button>`).join('') +
      `<span class="sc-step-title">${esc(st.title)}</span>`;
    $('#readme').innerHTML = full
      ? marked.parse(`### The whole script\n\nRead all the parts first: each one adds to the script, and a later part may change what an earlier one said. Your script must do everything below.\n\n` +
          d.steps.map(s => `---\n\n#### Part ${s.n} of ${d.steps.length} · ${s.title}\n\n${s.readme}`).join('\n\n'))
      : marked.parse(`### Step ${step} · ${st.title}\n\n` + st.readme);
    const load = $('#sc-load-btn');
    load.textContent = full || step === 1 ? 'Start over (empty file)' : `Load step ${step - 1} code`;
    load.title = full || step === 1 ? 'Replace your file with an empty template (your current file is archived first)' : `Replace your file with the reference code of step ${step - 1} (your current file is archived first)`;
    $('#result').classList.add('hidden');
    $('#statement-pane').scrollTop = 0;
    state.current.status = d.status;
    document.title = `${num(d.id)} · ${d.title}${full ? '' : ` — step ${step}`} — bash stash`;
  }
  $('#sc-steps').addEventListener('click', ev => {
    const b = ev.target.closest('[data-step]');
    if (b && cur) go(cur.id, b.dataset.step);
  });
  async function reload() {            // after a check: the passed steps changed
    const d = await (await api(`/${cur.id}`)).json();
    cur.d = d; fillStatement(); renderSidebar();
    await refresh();
  }

  let checking = false;
  async function runCheck() {
    if (!cur || checking) return;
    checking = true;
    const btn = $('#check-btn'), box = $('#result'), body = $('#result-body'), step = cur.step;
    btn.disabled = true; btn.textContent = '… checking';
    box.classList.remove('hidden', 'pass', 'fail'); unfoldResult();
    $('#result-title').textContent = isFull() ? 'Checking the script…' : `Checking step ${step}…`;
    body.innerHTML = '';
    if (typeof NewUser !== 'undefined') NewUser.clear();
    const res = await CheckView.run(`/api/scripts/${cur.id}/check?step=${step}`, body);
    const code = res.code, ok = code === '0';
    if (ok && isFull()) await fetch(`/api/scripts/${cur.id}/markall`, { method: 'POST' });     // the finished script passed: every step counts
    box.classList.add(ok ? 'pass' : 'fail');
    const last = cur.d.steps.length, sid = cur.id;
    $('#result-title').textContent = ok ? (step === last ? '✔ Script complete!' : `✔ Step ${step} passed — on to step ${step + 1}`) : code === '3' ? 'Not attempted yet' : '✘ Not yet';
    CheckView.show(body, res, { play: c => tryCase(`/api/scripts/${sid}/play?step=${step}&seed=${c.seed}`, c) });
    if (typeof NewUser !== 'undefined') NewUser.afterCheck({ ok, kind: 'script', id: sid, step, code });
    try { const keep = box.className, t = $('#result-title').textContent, h = body.innerHTML; await reload(); box.className = keep; $('#result-title').textContent = t; body.innerHTML = h; }
    finally { btn.disabled = false; btn.textContent = '▶ Check'; checking = false; }
  }
  async function showSolution() {
    if (!cur) return;
    const step = cur.step;
    if (!cur.d.passed.includes(step)) {
      const dlg = $('#confirm-dialog');
      dlg.returnValue = '';
      dlg.showModal();
      await new Promise(res => dlg.addEventListener('close', res, { once: true }));
      if (dlg.returnValue !== 'ok') return;
    }
    const r = await fetch(`/api/scripts/${cur.id}/solution?step=${step}`, { method: 'POST' });
    if (!r.ok) return;
    const sol = await r.json();
    $('#sol-title').textContent = `Solution · ${num(cur.id)} ${cur.d.title}${isFull() ? '' : ` · step ${step}`}`;
    $('#sol-file').textContent = sol.file;
    $('#sol-body').textContent = sol.content;
    $('#solution-dialog').showModal();
  }
  $('#sc-load-btn').onclick = async () => {
    if (!cur) return;
    const from = isFull() ? 0 : cur.step - 1;
    const msg = from === 0 ? 'Replace your file with an empty template? What you have now is archived first (.progress/scripts/<id>/archive).'
      : `Replace your file with the reference code of step ${from}? What you have now is archived first (.progress/scripts/<id>/archive).`;
    if (!confirm(msg)) return;
    await fetch(`/api/scripts/${cur.id}/load`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ step: from }) });
    openVSCode(state.current.answer);   // reload the editor on the new content
  };
  async function resetFixture() {
    if (!cur) return;
    const r = await fetch(`/api/scripts/${cur.id}/reset`, { method: 'POST' });
    const j = await r.json();
    if (j.playDir) { state.current.playDir = j.playDir; typeInTerminal(`cd ${shq(j.playDir)} && clear && ls`); }
  }
  function neighbour(delta) {       // ◀ ▶▶ move between the steps of the script, then between scripts
    if (!cur) return;
    const n = cur.step + delta;
    if (!isFull() && n >= 1 && n <= cur.d.steps.length) { go(cur.id, n); return; }
    const all = displayOrder(), i = all.findIndex(e => e.id === cur.id), o = all[i + delta];
    if (o) go(o.id, delta > 0 ? 1 : o.steps.length);
  }

  // ---------------------------------------------------------------- sidebar: every script, grouped
  function renderSidebar() {
    const nav = $('#topics');
    if (!cur) return;
    document.querySelector('.overall').title = 'exercises passed (scripts have their own counter)';
    renderSideView();
    nav.innerHTML = groups().map(g => {
      const es = g.items, done = es.filter(e => e.status === 'pass').length;
      return `<details class="topic" open><summary><span class="t-name">${esc(g.label)}</span><span class="t-count">${done}/${es.length}</span></summary>
        ${es.map(e => `<a class="ex-item${e.id === cur.id ? ' current' : ''}" href="#/script/${e.id}" title="${esc(e.title)}">
          <span class="dot ${e.status}">${STATUS[e.status].dot}</span><span class="ex-id">${num(e.id)}</span><span class="ex-name">${esc(e.title)}</span>
          <span class="t-count">${e.passed.length}/${e.steps.length}</span></a>`).join('')}</details>`;
    }).join('');
  }
  function leave() {
    document.body.classList.remove('script-run');
    $('#sidebar').classList.remove('script-mode');
    document.querySelector('.overall').title = 'exercises passed';
  }

  return { groups, doneCount, stars, load, list, entry, statusOf, open, go, refresh, renderHomeGrid, renderSidebar, runCheck, showSolution, resetFixture, neighbour, leave, current: () => cur };
})();
