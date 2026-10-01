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
  const list = () => index;
  const entry = id => index.find(e => e.id === id);
  const statusOf = e => e.status;
  async function refresh() { await load(); renderHomeGrid(); }
  const go = (id, step) => { location.hash = `#/script/${id}${step ? '/' + step : ''}`; };

  // ---------------------------------------------------------------- home grid
  function renderHomeGrid() {
    const grid = $('#scripts-grid');
    if (!index.length) { grid.innerHTML = '<p class="home-intro">No scripts built yet (run <code>node tools/build_scripts.js</code>).</p>'; return; }
    const groups = [...new Set(index.map(e => e.group))];
    grid.innerHTML = groups.map(g => {
      const es = index.filter(e => e.group === g);
      const card = e => `<button class="track-card exam-card${state.script === e.id ? ' current' : ''}" data-script="${esc(e.id)}">
        <div class="track-card-title">${num(e.id)} · ${esc(e.title)}</div>
        <div class="track-card-desc"><code>${esc(e.script)}</code> · ${e.steps.length} steps</div>
        <div class="track-card-count"><span class="${e.status === 'pass' ? 'exam-best good' : ''}">${e.passed.length}/${e.steps.length} steps passed</span></div></button>`;
      return `<h3 class="home-tier-title">${esc(g)} <span>${es.filter(e => e.status === 'pass').length}/${es.length} done</span></h3>
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
    const step = d.steps.some(s => s.n === Number(stepArg)) ? Number(stepArg) : d.current;
    const sameScript = cur && cur.id === id && state.script === id;
    cur = { id, d, step };
    state.script = id; state.theory = null; state.exam = null; state.sexam = null;
    state.current = { id, sc: true, title: `${num(id)} · ${d.title}`, level: 0, cmds: d.cmds, status: d.status, topic: d.group,
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
    $('#ex-topic').textContent = `Scripts · ${d.group}`;
    $('#ex-title').textContent = `${num(d.id)} · ${d.title}`;
    $('#ex-level').textContent = `Step ${step} of ${d.steps.length}`;
    $('#ex-cmds').textContent = d.cmds;
    const b = $('#ex-status');
    b.className = 'badge ' + d.status; b.textContent = STATUS[d.status].label;
    $('#answer-path').textContent = 'script: ' + d.answer.replace(/^\/home\/alumno\/lab\//, '');
    $('#sc-steps').innerHTML = d.steps.map(s => `<button class="sc-step${s.n === step ? ' active' : ''}${d.passed.includes(s.n) ? ' done' : ''}" data-step="${s.n}" title="${esc(s.title)}">${d.passed.includes(s.n) ? '✓' : ''}${s.n}</button>`).join('') +
      `<span class="sc-step-title">${esc(st.title)}</span>`;
    $('#readme').innerHTML = marked.parse(`### Step ${step} · ${st.title}\n\n` + st.readme);
    const load = $('#sc-load-btn');
    load.textContent = step === 1 ? 'Start over (empty file)' : `Load step ${step - 1} code`;
    load.title = step === 1 ? 'Replace your file with an empty template (your current file is archived first)' : `Replace your file with the reference code of step ${step - 1} (your current file is archived first)`;
    $('#result').classList.add('hidden');
    $('#statement-pane').scrollTop = 0;
    state.current.status = d.status;
    document.title = `${num(d.id)} · ${d.title} — step ${step} — bash stash`;
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
    box.classList.remove('hidden', 'pass', 'fail');
    $('#result-title').textContent = `Checking step ${step}…`;
    body.innerHTML = '';
    let text = '';
    try {
      const r = await fetch(`/api/scripts/${cur.id}/check?step=${step}`, { method: 'POST' });
      const reader = r.body.getReader(), dec = new TextDecoder();
      for (;;) {
        const { value, done } = await reader.read();
        if (done) break;
        text += dec.decode(value, { stream: true });
        body.innerHTML = ansiToHtml(text);
      }
    } catch (e) { text += `\n${e}`; body.textContent = text; }
    const code = ([...text.matchAll(/\[exit (\d+)\]/g)].pop() || [])[1];
    const ok = code === '0';
    box.classList.add(ok ? 'pass' : 'fail');
    const last = cur.d.steps.length;
    $('#result-title').textContent = ok ? (step === last ? '✔ Script complete!' : `✔ Step ${step} passed — on to step ${step + 1}`) : code === '3' ? 'Not attempted yet' : '✘ Not yet';
    body.innerHTML = ansiToHtml(text.replace(/\n?\x1b\[2m\[exit \d+\]\x1b\[0m\s*$/, ''));
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
    $('#sol-title').textContent = `Solution · ${num(cur.id)} ${cur.d.title} · step ${step}`;
    $('#sol-file').textContent = sol.file;
    $('#sol-body').textContent = sol.content;
    $('#solution-dialog').showModal();
  }
  $('#sc-load-btn').onclick = async () => {
    if (!cur) return;
    const from = cur.step - 1;
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
    if (n >= 1 && n <= cur.d.steps.length) { go(cur.id, n); return; }
    const i = index.findIndex(e => e.id === cur.id), o = index[i + delta];
    if (o) go(o.id, delta > 0 ? 1 : o.steps.length);
  }

  // ---------------------------------------------------------------- sidebar: every script, grouped
  function renderSidebar() {
    const nav = $('#topics');
    if (!cur) return;
    document.querySelector('.overall').title = 'exercises passed (scripts have their own counter)';
    const groups = [...new Set(index.map(e => e.group))];
    nav.innerHTML = groups.map(g => {
      const es = index.filter(e => e.group === g), done = es.filter(e => e.status === 'pass').length;
      return `<details class="topic" open><summary><span class="t-name">${esc(g)}</span><span class="t-count">${done}/${es.length}</span></summary>
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

  return { load, list, entry, statusOf, open, go, refresh, renderHomeGrid, renderSidebar, runCheck, showSolution, resetFixture, neighbour, leave, current: () => cur };
})();
