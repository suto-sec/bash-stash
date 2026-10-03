// bash stash — the Imported tab of the home page: pick one or several pack files (JSON), see what is wrong with each of them before anything
// is saved, import them, list / rename / delete the imported packs, read the history of what happened to them, and download the prompt that
// tells an LLM how to write a pack (web/import-prompt.md).
// Imported quizzes and exams are served by the ordinary theory / exam APIs (flagged `imp`) and open in the usual screens; this module only
// draws the Imported tab. Format and checks: web/importer.js (+ web/scanner.js for code); storage, consent, snapshots, history: web/server.js.
// A pack with scripts contains CODE: it is shown (here and before the first run), the user allows it per pack, and it runs in the sandbox only.
'use strict';
const Imp = (() => {
  const $1 = id => document.getElementById(id);
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const json = (url, opt) => fetch(url, opt).then(r => r.json());
  let packs = [], history = [];
  let batch = [];            // the files chosen last: { n, name, state: checking | ok | bad | busy | done | failed | skipped, j, text, note }
  let renaming = null;       // id of the pack whose name is being edited
  let replaceAll = false;    // "replace packs that are already imported" for "Import all"
  let seq = 0;
  let selftest = null;       // the last self-test of a pack: { id, running | error | results }

  async function loadPacks() {
    try { packs = await json('/api/import'); } catch { packs = []; }
    if (!Array.isArray(packs)) packs = [];
    try { history = await json('/api/import/history'); } catch { history = []; }
    if (!Array.isArray(history)) history = [];
  }
  const KIND = { quiz: 'quiz', exam: 'practice exam', script: 'script' };
const COUNT_WORD = { quiz: 'question', exam: 'question', script: 'step' };
  const when = iso => { try { return new Date(iso).toLocaleDateString(undefined, { dateStyle: 'medium' }); } catch { return ''; } };
  const whenFull = iso => { try { return new Date(iso).toLocaleString(undefined, { dateStyle: 'medium', timeStyle: 'short' }); } catch { return ''; } };
  const plural = (n, w) => `${n} ${w}${n === 1 ? '' : 's'}`;


  // ---------------------------------------------------------------- code: shown before it is allowed
  const codeBox = (title, c) => `<details class="imp-code"${c.findings && c.findings.some(f => f.level !== 'info') ? ' open' : ''}><summary>${esc(title)}${c.findings && c.findings.length ? ` <span class="imp-flag">${plural(c.findings.length, 'note')}</span>` : ''}</summary>
      ${c.findings && c.findings.length ? `<ul class="imp-list ${c.findings.some(f => f.level === 'red') ? 'imp-errors' : 'imp-warns'}">${c.findings.map(f => `<li>line ${f.line}: ${esc(f.msg)} <code>${esc(f.snippet || '')}</code></li>`).join('')}</ul>` : ''}
      <pre class="imp-pre">${esc(c.code || '(empty)')}</pre></details>`;
  const codeHtml = d => d.items.map(it => `<div class="imp-code-item"><h4>${esc(it.title)} <span class="hint">${esc(it.script)}</span></h4>
      ${it.fixture && it.fixture.code ? codeBox('Fixture (builds the test files)', it.fixture) : ''}
      ${it.steps.map(st => `${codeBox(`Step ${st.n} · ${st.title}: the checker`, st.check)}${codeBox(`Step ${st.n}: the reference solution`, st.solution)}`).join('')}</div>`).join('');
  async function askConsent(id) {                // -> true when the user allowed the pack
    let d;
    try { d = await json(`/api/import/${encodeURIComponent(id)}/code`); } catch { alert('The code of the pack could not be loaded.'); return false; }
    let dlg = $1('imp-dialog');
    if (!dlg) { dlg = document.createElement('dialog'); dlg.id = 'imp-dialog'; document.body.appendChild(dlg); }
    const already = d.consented;
    dlg.innerHTML = `<form method="dialog" class="imp-dlg">
      <div class="dlg-head"><strong>${already ? 'Code of' : 'Allow'} “${esc(d.title)}”${already ? '' : '?'}</strong><button class="icon-btn" value="no" aria-label="Close">✕</button></div>
      <div class="imp-dlg-body">
        ${already ? '<p class="hint">This pack is allowed to run. Its code is below.</p>' : `<p><b>This pack contains code.</b> Its checkers and fixtures are programs that run in the lab when you press Check or open one of its scripts.</p>
        <ul class="imp-dlg-list"><li>They run in a <b>sandbox</b>: a time limit${d.sandboxNoNet === false ? '' : ' and no network'}, a throw-away working folder, and only the lab user's permissions.</li>
          <li>Before the first run a <b>snapshot of your progress and answer files</b> is saved. “Roll back” in the pack list restores it.</li>
          <li>The pack was read when imported; anything unusual is listed in the notes below. Read it, then decide.</li></ul>`}
        ${codeHtml(d)}
      </div>
      <div class="dlg-actions">${already ? '<button value="no">Close</button>' : '<button value="no">Cancel</button><button value="yes" class="primary">I have read it: allow this pack</button>'}</div></form>`;
    return new Promise(resolve => {
      dlg.addEventListener('close', async () => {
        if (dlg.returnValue !== 'yes') { resolve(false); return; }
        const r = await fetch(`/api/import/${encodeURIComponent(id)}/consent`, { method: 'POST' });
        if (!r.ok) { alert((await r.json()).error || 'The pack could not be allowed.'); resolve(false); return; }
        await refresh();
        resolve(true);
      }, { once: true });
      dlg.returnValue = ''; dlg.showModal();
    });
  }
  async function selfTest(id) {
    selftest = { id, running: true }; renderLoad();
    const r = await fetch(`/api/import/${encodeURIComponent(id)}/selftest`, { method: 'POST' });
    selftest = r.ok ? { id, results: (await r.json()).results } : { id, error: (await r.json().catch(() => ({}))).error || 'The self-test failed.' };
    await loadPacks(); renderLoad(); renderHistory();
  }
  const selftestHtml = () => {
    if (!selftest) return '';
    if (selftest.running) return '<div class="imp-report"><div class="hint">Running the self-test: every step is checked with its own solution and with an empty script…</div></div>';
    if (selftest.error) return `<div class="imp-report"><div class="imp-bad">${esc(selftest.error)}</div></div>`;
    const bad = selftest.results.filter(r => !r.refPasses || !r.emptyFails || r.previousFails === false);
    return `<div class="imp-report"><div class="${bad.length ? 'imp-bad' : 'imp-ok'}"><b>Self-test of “${esc(selftest.id)}”:</b> ${bad.length ? `${plural(bad.length, 'step')} to fix` : `all ${selftest.results.length} steps are fine`}.</div>
      <ul class="imp-list">${selftest.results.map(r => `<li class="${!r.refPasses || !r.emptyFails || r.previousFails === false ? 'imp-errors' : ''}"><b>${esc(r.title)} · step ${r.n}</b> (${esc(r.stepTitle)}): its own solution ${r.refPasses ? 'passes ✓' : 'does NOT pass ✗'}; an empty script ${r.emptyFails ? 'fails ✓' : 'passes ✗ (the checker tests nothing)'}${r.previousFails === null ? '' : `; the previous step's solution ${r.previousFails ? 'fails ✓' : 'passes ✗ (this step adds nothing the checker can see)'}`}${r.detail ? `<pre class="imp-pre">${esc(r.detail)}</pre>` : ''}</li>`).join('')}</ul>
      <button type="button" class="small" id="imp-st-close">Close</button></div>`;
  };

  // ---------------------------------------------------------------- the "Import a pack" section
  const problems = (list, cls, max = 8) => {
    if (!list.length) return '';
    const li = x => `<li><b>${esc(x.at)}</b>: ${esc(x.msg)}</li>`;
    return `<ul class="imp-list ${cls}">${list.slice(0, max).map(li).join('')}</ul>${list.length > max ? `<details class="imp-more"><summary>${list.length - max} more</summary><ul class="imp-list ${cls}">${list.slice(max).map(li).join('')}</ul></details>` : ''}`;
  };
  const okItems = () => batch.filter(f => f.state === 'ok');
  const dupOf = f => batch.find(g => g !== f && g.state === 'ok' && f.state === 'ok' && g.n < f.n && g.j.summary.id === f.j.summary.id);
  // before the import: what the code of the file looks like (read from the file in the browser; the checks already ran on the server)
  function previewCode(f) {
    let items = [];
    try { items = JSON.parse(f.text).items.filter(i => i && i.kind === 'script'); } catch { /* the server accepted it, so this is a formality */ }
    const d = { items: items.map(i => ({ title: String(i.title), script: String(i.script), fixture: i.fixture ? { code: i.fixture } : null,
      steps: (i.steps || []).map(st => ({ n: st.n || '', title: String(st.title), check: { code: st.check }, solution: { code: st.solution } })) })) };
    d.items.forEach(it => it.steps.forEach((st, i) => { st.n = i + 1; }));
    return `<div class="imp-codenote"><b>This pack contains code</b> (${plural(items.length, 'script')}). It does not run now: you will see it again, and have to allow the pack, before it runs the first time.
      <details class="imp-code"><summary>Read the code now</summary>${codeHtml(d)}</details></div>`;
  }
  function fileCard(f) {
    const head = (cls, label) => `<div class="imp-file-head"><b>${esc(f.name)}</b><span class="imp-state ${cls}">${label}</span></div>`;
    if (f.state === 'checking') return `<div class="imp-file">${head('', 'checking…')}</div>`;
    if (f.state === 'bad') {
      const j = f.j;
      return `<div class="imp-file imp-file-bad">${head('bad', 'refused')}
        <div class="imp-bad">${j.errors.length}${j.moreErrors ? '+' : ''} problem${j.errors.length === 1 ? '' : 's'} to fix${j.moreErrors ? ` (${j.moreErrors} more not shown)` : ''}:</div>${problems(j.errors, 'imp-errors')}${problems(j.warnings || [], 'imp-warns', 3)}</div>`;
    }
    if (f.state === 'done') return `<div class="imp-file imp-file-ok">${head('ok', esc(f.note))}<div class="imp-ok">${esc(f.j.summary.title)} <span class="hint">(${esc(f.j.summary.id)})</span></div></div>`;
    if (f.state === 'failed' || f.state === 'skipped') return `<div class="imp-file ${f.state === 'failed' ? 'imp-file-bad' : ''}">${head(f.state === 'failed' ? 'bad' : '', f.state)}<div class="${f.state === 'failed' ? 'imp-bad' : 'hint'}">${esc(f.note)}</div></div>`;
    const s = f.j.summary, d = dupOf(f);
    return `<div class="imp-file imp-file-ok">${head('ok', f.state === 'busy' ? 'importing…' : 'valid')}
      <div class="imp-ok"><b>${esc(s.title)}</b> <span class="hint">(${esc(s.id)})</span>: ${s.items.map(i => `${esc(KIND[i.kind])} “${esc(i.title)}” (${plural(i.count, COUNT_WORD[i.kind] || 'item')})`).join(', ')}.</div>
      ${s.code ? previewCode(f) : ''}
      ${f.j.warnings.length ? `<div class="imp-warn-head">${plural(f.j.warnings.length, 'warning')} (the pack can still be imported):</div>${problems(f.j.warnings, 'imp-warns', 4)}` : ''}
      ${d ? `<div class="imp-warn-head">Same pack id as ${esc(d.name)}: importing both makes the second replace the first.</div>` : ''}
      ${f.j.exists ? `<div class="hint">A pack called <b>${esc(s.id)}</b> is already imported: importing replaces it (your progress on questions that keep their id is kept).</div>` : ''}
      <div class="imp-file-actions"><button type="button" class="hc-btn" data-imp-one="${f.n}"${f.state === 'busy' ? ' disabled' : ''}>${f.j.exists ? 'Replace the pack' : 'Import the pack'}</button></div></div>`;
  }
  function batchHtml() {
    if (!batch.length) return '';
    const ok = okItems().filter(f => !dupOf(f)), exist = ok.filter(f => f.j.exists).length;
    const bar = batch.length > 1 || ok.length ? `<div class="imp-batch-bar">
        ${ok.length > 1 ? `<button type="button" class="hc-btn" id="imp-all">Import all valid (${ok.length - (replaceAll ? 0 : exist) })</button>` : ''}
        ${exist && ok.length > 1 ? `<label class="imp-check"><input type="checkbox" id="imp-replace"${replaceAll ? ' checked' : ''}> also replace the ${exist} already imported</label>` : ''}
        <button type="button" id="imp-clear">Clear these results</button></div>` : '';
    return `${bar}${batch.map(fileCard).join('')}`;
  }
  function packRow(p) {
    const edit = renaming === p.id;
    return `<li class="imp-pack"><div class="imp-pack-head">
        ${edit ? `<input type="text" class="imp-name" id="imp-name" value="${esc(p.title)}" maxlength="200"><button type="button" class="small" data-save="${esc(p.id)}">Save</button><button type="button" class="small" data-cancel="1">Cancel</button>`
               : `<b>${esc(p.title)}</b> <span class="hint">${esc(p.id)} · ${esc(when(p.addedAt))}</span>
                  <span class="imp-pack-btns"><button type="button" class="small" data-rename="${esc(p.id)}">Rename</button><button type="button" class="small imp-del" data-del="${esc(p.id)}">Delete</button></span>`}
      </div>
      ${p.description ? `<div class="hint">${esc(p.description)}</div>` : ''}
      ${p.code ? `<div class="imp-codebar"><span class="imp-flag">contains code</span>
        ${p.consented ? `<span class="hint">allowed ${esc(when(p.consentAt))} · runs in the sandbox</span>` : '<span class="imp-bad">not allowed yet</span>'}
        <button type="button" class="small" data-viewcode="${esc(p.id)}">View code</button>
        ${p.consented ? `<button type="button" class="small" data-selftest="${esc(p.id)}">Self-test</button>` : `<button type="button" class="small" data-allow="${esc(p.id)}">Review and allow…</button>`}
        ${p.snapshotAt ? `<button type="button" class="small" data-rollback="${esc(p.id)}" title="Restore your progress and answer files to what they were before this pack first ran">Roll back…</button>` : ''}</div>` : ''}
      <div class="imp-pack-items">${p.items.map(i => `<span class="ex-chip" title="${esc(i.title)}">${esc(KIND[i.kind] || i.kind)}: ${esc(i.title)} · ${i.count}</span>`).join('')}</div></li>`;
  }
  function renderLoad() {
    const box = $1('imp-load');
    if (!box) return;
    const keepName = $1('imp-name') ? $1('imp-name').value : null;
    box.innerHTML = `
      <div class="imp-drop" id="imp-drop">
        <div class="imp-drop-text"><b>Choose one or more pack files</b> (.json) or drop them here</div>
        <button type="button" class="hc-btn" id="imp-pick">Choose files…</button>
        <input type="file" id="imp-file" accept=".json,application/json,text/plain" multiple hidden>
      </div>
      <div class="imp-actions">
        <a class="top-btn" href="/api/import/prompt.md" download>⬇ Prompt for an AI assistant (.md)</a>
        <a class="top-btn" href="/api/import/example.json" download>⬇ Example pack (.json)</a>
        <span class="hint">Give the prompt to an AI assistant, tell it the topic, and import the files it writes.</span>
      </div>
      <div id="imp-report" class="imp-report">${batchHtml()}</div>
      ${selftestHtml()}
      <h3 class="home-sub">Imported packs</h3>
      ${packs.length ? `<ul class="imp-packs">${packs.map(packRow).join('')}</ul>` : '<p class="hint">Nothing imported yet.</p>'}`;
    if (renaming && $1('imp-name')) { const i = $1('imp-name'); if (keepName !== null) i.value = keepName; i.focus(); i.select(); }
  }

  // ---------------------------------------------------------------- history
  const ACTION = { added: 'added', replaced: 'replaced', removed: 'removed', renamed: 'renamed', allowed: 'allowed', 'rolled back': 'rolled back', 'self-test': 'self-test' };
  function renderHistory() {
    const box = $1('imp-history');
    if (!box) return;
    box.innerHTML = history.length ? `<ul class="imp-hist">${history.map(h => `<li><span class="imp-when">${esc(whenFull(h.at))}</span>
        <span class="imp-act ${esc(h.action.replace(/ /g, '-'))}">${esc(ACTION[h.action] || h.action)}</span>
        <span class="imp-hist-main"><b>${esc(h.title)}</b> <span class="hint">${esc(h.pack)}${h.detail ? ' · ' + esc(h.detail) : ''}</span></span></li>`).join('')}</ul>
      <button type="button" class="small" id="imp-hist-clear">Clear the history</button>` : '<p class="hint">Nothing has happened yet: imports, replacements, renames and deletions are listed here.</p>';
  }

  // ---------------------------------------------------------------- the checks and the imports
  async function check(fileList) {
    const files = [...fileList];
    if (!files.length) return;
    batch = [];
    const items = files.map(f => ({ n: ++seq, name: f.name, state: 'checking', file: f }));
    batch = items; renderLoad();
    for (const it of items) {
      if (it.file.size > 3e6) { it.state = 'bad'; it.j = { errors: [{ at: 'file', msg: 'The file is too big (at most 3 MB).' }], warnings: [] }; continue; }
      try { it.text = await it.file.text(); } catch { it.state = 'bad'; it.j = { errors: [{ at: 'file', msg: 'The file could not be read.' }], warnings: [] }; continue; }
      try {
        it.j = await json('/api/import/validate', { method: 'POST', headers: { 'Content-Type': 'text/plain' }, body: it.text });
        it.state = it.j.ok ? 'ok' : 'bad';
      } catch { it.state = 'failed'; it.note = 'The server did not answer.'; }
      delete it.file;
      renderLoad();
    }
    for (const it of items) delete it.file;
    renderLoad();
  }
  async function importOne(f) {
    f.state = 'busy'; renderLoad();
    try {
      const r = await json('/api/import?file=' + encodeURIComponent(f.name) + (f.j.exists || batch.some(g => g.state === 'done' && g.j.summary.id === f.j.summary.id) ? '&replace=1' : ''), { method: 'POST', headers: { 'Content-Type': 'text/plain' }, body: f.text });
      if (r.ok) { f.state = 'done'; f.note = f.j.exists ? 'replaced' : 'imported'; f.text = null; }
      else { f.state = 'failed'; f.note = (r.errors || []).map(e => e.msg).join(' ') || 'Not imported.'; }
    } catch { f.state = 'failed'; f.note = 'The server did not answer.'; }
  }
  async function importAll() {
    for (const f of okItems().filter(x => !dupOf(x))) {
      if (f.j.exists && !replaceAll) { f.state = 'skipped'; f.note = `A pack called ${f.j.summary.id} is already imported: tick “also replace” or use its own button.`; continue; }
      await importOne(f);
    }
    await refresh();
  }
  async function deletePack(id) {
    const p = packs.find(x => x.id === id);
    if (!p || !confirm(`Delete the pack "${p.title}"?\n\nYour progress on its quizzes and exams is deleted too.`)) return;
    await fetch(`/api/import/${encodeURIComponent(id)}/delete`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ progress: true }) });
    await refresh();
  }
  async function rollback(id) {
    const p = packs.find(x => x.id === id);
    if (!p || !confirm(`Roll back to before “${p.title}” first ran?\n\nYour progress and your answer files are restored to what they were at ${whenFull(p.snapshotAt)}. Everything you did or wrote since is lost (except the imported packs themselves).`)) return;
    const r = await fetch(`/api/import/${encodeURIComponent(id)}/rollback`, { method: 'POST' });
    if (!r.ok) { alert((await r.json()).error || 'Not rolled back.'); return; }
    alert('Done: your progress and answer files are back to the snapshot. Reloading.');
    location.reload();
  }
  async function saveName(id) {
    const title = ($1('imp-name') || {}).value || '';
    const r = await fetch(`/api/import/${encodeURIComponent(id)}/rename`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ title }) });
    if (!r.ok) { alert((await r.json()).error || 'Not renamed.'); return; }
    renaming = null;
    await refresh();
  }

  // ---------------------------------------------------------------- the lists of imported items
  function byPack(list, card) {
    if (!list.length) return '<p class="home-intro">Nothing here yet: import a pack that has this kind of item.</p>';
    const order = [...new Set(list.map(x => x.packTitle || x.imp))];
    return order.map(t => `<h3 class="home-tier-title">${esc(t)}</h3><div class="track-grid exam-grid">${list.filter(x => (x.packTitle || x.imp) === t).map(card).join('')}</div>`).join('');
  }
  function renderLists() {
    const q = $1('imp-quizzes-grid'), e = $1('imp-exams-grid');
    if (q) q.innerHTML = byPack(Theory.imported(), Theory.cardHTML);
    if (e) e.innerHTML = byPack(Exams.imported(), Exams.cardHTML);
    const sc = $1('imp-scripts-grid');
    if (sc) sc.innerHTML = byPack(Scripts.imported(), x => `<button class="track-card exam-card${state.script === x.id ? ' current' : ''}" data-script="${esc(x.id)}">
        <div class="track-card-title">${esc(x.title)}</div>
        <div class="track-card-desc"><span class="stars">${Scripts.stars(x.level)}</span> · <code>${esc(x.script)}</code> · ${plural(x.steps.length, 'step')}</div>
        <div class="track-card-desc">${x.tags.map(esc).join(' · ')}</div>
        <div class="track-card-count">${x.consent ? `<span class="${x.status === 'pass' ? 'exam-best good' : ''}">${x.passed.length}/${x.steps.length} steps passed</span>` : '<span class="imp-bad">needs your OK before it runs</span>'}</div></button>`);
  }
  async function refresh() {
    await Promise.all([loadPacks(), Theory.load(), Exams.load(), Scripts.load()]);
    renderLoad(); renderLists(); renderHistory();
    if (typeof renderHomeNav === 'function') renderHomeNav();
    if (typeof Home !== 'undefined') Home.refresh();
  }

  // ---------------------------------------------------------------- events
  document.addEventListener('click', ev => {
    const t = ev.target, one = t.closest('[data-imp-one]');
    if (t.closest('#imp-pick')) $1('imp-file').click();
    else if (one) importOne(batch.find(f => f.n === Number(one.dataset.impOne))).then(refresh);
    else if (t.closest('#imp-all')) importAll();
    else if (t.closest('#imp-clear')) { batch = []; renderLoad(); }
    else if (t.closest('[data-rename]')) { renaming = t.closest('[data-rename]').dataset.rename; renderLoad(); }
    else if (t.closest('[data-cancel]')) { renaming = null; renderLoad(); }
    else if (t.closest('[data-save]')) saveName(t.closest('[data-save]').dataset.save);
    else if (t.closest('[data-del]')) deletePack(t.closest('[data-del]').dataset.del);
    else if (t.closest('#imp-hist-clear')) { if (confirm('Clear the history of imported packs?')) fetch('/api/import/history/clear', { method: 'POST' }).then(refresh); }
    else if (t.closest('[data-viewcode]')) askConsent(t.closest('[data-viewcode]').dataset.viewcode);
    else if (t.closest('[data-allow]')) askConsent(t.closest('[data-allow]').dataset.allow);
    else if (t.closest('[data-selftest]')) selfTest(t.closest('[data-selftest]').dataset.selftest);
    else if (t.closest('#imp-st-close')) { selftest = null; renderLoad(); }
    else if (t.closest('[data-rollback]')) rollback(t.closest('[data-rollback]').dataset.rollback);
    else if (t.closest('#imp-scripts-grid [data-script]')) { const e = Scripts.entry(t.closest('[data-script]').dataset.script); Scripts.go(e.id, (e.steps.find(x => !e.passed.includes(x.n)) || e.steps[e.steps.length - 1]).n); }
    else if (t.closest('#imp-quizzes-grid [data-theory]')) Theory.go(t.closest('[data-theory]').dataset.theory);
    else if (t.closest('#imp-exams-grid [data-exam]')) Exams.go(t.closest('[data-exam]').dataset.exam);
  });
  document.addEventListener('change', ev => {
    if (ev.target.id === 'imp-file') { check(ev.target.files); ev.target.value = ''; }
    else if (ev.target.id === 'imp-replace') { replaceAll = ev.target.checked; renderLoad(); }
  });
  document.addEventListener('keydown', ev => {
    if (ev.target.id !== 'imp-name') return;
    if (ev.key === 'Enter') { ev.preventDefault(); saveName(renaming); }
    else if (ev.key === 'Escape') { ev.stopPropagation(); renaming = null; renderLoad(); }
  }, true);
  // dropping files anywhere on the Imported tab
  const tab = () => document.getElementById('home-page') && document.getElementById('home-page').dataset.tab === 'imported';
  document.addEventListener('dragover', ev => { if (tab() && ev.dataTransfer && [...ev.dataTransfer.types].includes('Files')) { ev.preventDefault(); const d = $1('imp-drop'); if (d) d.classList.add('over'); } });
  document.addEventListener('dragleave', ev => { if (ev.target.id === 'imp-drop' || !ev.relatedTarget) { const d = $1('imp-drop'); if (d) d.classList.remove('over'); } });
  document.addEventListener('drop', ev => {
    if (!tab() || !ev.dataTransfer || !ev.dataTransfer.files.length) return;
    ev.preventDefault();
    const d = $1('imp-drop'); if (d) d.classList.remove('over');
    check(ev.dataTransfer.files);
  });

  // the first drawing (the lists are redrawn every time the home page is drawn: app.js renderHomePage)
  (async () => { await loadPacks(); renderLoad(); renderLists(); renderHistory(); if (typeof Home !== 'undefined') Home.refresh(); })();
  return { refresh, askConsent, packCount: () => packs.length, historyCount: () => history.length, renderLists };
})();
