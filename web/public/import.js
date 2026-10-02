// bash stash — the Imported tab of the home page: pick a pack (one JSON file), see what is wrong with it before anything is saved, import it,
// list and delete the imported packs, and download the prompt that tells an LLM how to write one (web/import-prompt.md).
// Imported quizzes and exams are served by the ordinary theory / exam APIs (flagged `imp`) and open in the usual screens; this module only
// draws the Imported tab. Format and checks: web/importer.js.
'use strict';
const Imp = (() => {
  const $1 = id => document.getElementById(id);
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  let packs = [];
  let pending = null;      // { text, name, summary, exists, warnings } a file that passed the check and waits for "Import"
  let report = '';         // html of the last check result

  async function loadPacks() {
    try { packs = await (await fetch('/api/import')).json(); } catch { packs = []; }
    if (!Array.isArray(packs)) packs = [];
  }
  const KIND = { quiz: 'quiz', exam: 'practice exam' };
  const when = iso => { try { return new Date(iso).toLocaleDateString(undefined, { dateStyle: 'medium' }); } catch { return ''; } };
  const plural = (n, w) => `${n} ${w}${n === 1 ? '' : 's'}`;

  // ---------------------------------------------------------------- the "Import a pack" section
  function renderLoad() {
    const box = $1('imp-load');
    if (!box) return;
    box.innerHTML = `
      <div class="imp-drop" id="imp-drop">
        <div class="imp-drop-text"><b>Choose a pack file</b> (.json) or drop it here</div>
        <button type="button" class="hc-btn" id="imp-pick">Choose file…</button>
        <input type="file" id="imp-file" accept=".json,application/json,text/plain" hidden>
      </div>
      <div class="imp-actions">
        <a class="top-btn" href="/api/import/prompt.md" download>⬇ Prompt for an AI assistant (.md)</a>
        <a class="top-btn" href="/api/import/example.json" download>⬇ Example pack (.json)</a>
        <span class="hint">Give the prompt to an AI assistant, tell it the topic, and import the file it writes.</span>
      </div>
      <div id="imp-report" class="imp-report">${report}</div>
      <h3 class="home-sub">Imported packs</h3>
      ${packs.length ? `<ul class="imp-packs">${packs.map(p => `<li class="imp-pack">
          <div class="imp-pack-head"><b>${esc(p.title)}</b> <span class="hint">${esc(p.id)} · ${esc(when(p.addedAt))}</span>
            <button type="button" class="small imp-del" data-del="${esc(p.id)}">Delete</button></div>
          ${p.description ? `<div class="hint">${esc(p.description)}</div>` : ''}
          <div class="imp-pack-items">${p.items.map(i => `<span class="ex-chip" title="${esc(i.title)}">${esc(KIND[i.kind] || i.kind)}: ${esc(i.title)} · ${i.count}</span>`).join('')}</div>
        </li>`).join('')}</ul>` : '<p class="hint">Nothing imported yet.</p>'}`;
  }

  // ---------------------------------------------------------------- the check and the import
  const problems = (list, cls) => list.length ? `<ul class="imp-list ${cls}">${list.map(x => `<li><b>${esc(x.at)}</b>: ${esc(x.msg)}</li>`).join('')}</ul>` : '';
  async function check(file) {
    pending = null;
    if (!file) return;
    if (file.size > 3e6) { report = `<div class="imp-bad"><b>${esc(file.name)}</b> is too big (at most 3 MB).</div>`; renderLoad(); return; }
    report = `<div class="hint">Checking ${esc(file.name)}…</div>`; renderLoad();
    let text;
    try { text = await file.text(); } catch { report = '<div class="imp-bad">The file could not be read.</div>'; renderLoad(); return; }
    let res, j;
    try { res = await fetch('/api/import/validate', { method: 'POST', headers: { 'Content-Type': 'text/plain' }, body: text }); j = await res.json(); }
    catch { report = '<div class="imp-bad">The server did not answer.</div>'; renderLoad(); return; }
    if (!j.ok) {
      report = `<div class="imp-bad"><b>${esc(file.name)} was not imported.</b> ${j.errors.length}${j.moreErrors ? '+' : ''} problem${j.errors.length === 1 ? '' : 's'} to fix${j.moreErrors ? ` (${j.moreErrors} more not shown)` : ''}:</div>${problems(j.errors, 'imp-errors')}${problems(j.warnings || [], 'imp-warns')}
        <p class="hint">Fix them (or give this list to the assistant that wrote the file) and choose the file again.</p>`;
    } else {
      pending = { text, name: file.name, summary: j.summary, exists: j.exists };
      const s = j.summary;
      report = `<div class="imp-ok"><b>${esc(s.title)}</b> <span class="hint">(${esc(s.id)})</span> is valid: ${s.items.map(i => `${esc(KIND[i.kind])} “${esc(i.title)}” (${plural(i.count, 'question')})`).join(', ')}.</div>
        ${j.warnings.length ? `<div class="imp-warn-head">${plural(j.warnings.length, 'warning')} (the pack can still be imported):</div>${problems(j.warnings, 'imp-warns')}` : ''}
        ${j.exists ? `<p class="hint">A pack called <b>${esc(s.id)}</b> is already imported: importing replaces it (your progress on questions that keep their id is kept).</p>` : ''}
        <button type="button" class="hc-btn" id="imp-go">${j.exists ? 'Replace the pack' : 'Import the pack'}</button>
        <button type="button" id="imp-cancel">Cancel</button>`;
    }
    renderLoad();
  }
  async function doImport() {
    if (!pending) return;
    const { text, summary, exists } = pending;
    let res, j;
    try { res = await fetch('/api/import' + (exists ? '?replace=1' : ''), { method: 'POST', headers: { 'Content-Type': 'text/plain' }, body: text }); j = await res.json(); }
    catch { report = '<div class="imp-bad">The server did not answer.</div>'; renderLoad(); return; }
    pending = null;
    if (!j.ok) { report = `<div class="imp-bad">Not imported.</div>${problems(j.errors || [], 'imp-errors')}`; renderLoad(); return; }
    report = `<div class="imp-ok"><b>${esc(summary.title)}</b> imported: ${summary.items.map(i => esc(i.title)).join(', ')}.</div>`;
    await refresh();
  }
  async function deletePack(id) {
    const p = packs.find(x => x.id === id);
    if (!p || !confirm(`Delete the pack "${p.title}"?\n\nYour progress on its quizzes and exams is deleted too.`)) return;
    await fetch(`/api/import/${encodeURIComponent(id)}/delete`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ progress: true }) });
    report = `<div class="imp-ok">Pack “${esc(p.title)}” deleted.</div>`;
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
  }
  async function refresh() {
    await Promise.all([loadPacks(), Theory.load(), Exams.load()]);
    renderLoad(); renderLists();
    if (typeof renderHomeNav === 'function') renderHomeNav();
    if (typeof Home !== 'undefined') Home.refresh();
  }

  // ---------------------------------------------------------------- events
  document.addEventListener('click', ev => {
    const t = ev.target;
    if (t.closest('#imp-pick')) $1('imp-file').click();
    else if (t.closest('#imp-go')) doImport();
    else if (t.closest('#imp-cancel')) { pending = null; report = ''; renderLoad(); }
    else if (t.closest('[data-del]')) deletePack(t.closest('[data-del]').dataset.del);
    else if (t.closest('#imp-quizzes-grid [data-theory]')) Theory.go(t.closest('[data-theory]').dataset.theory);
    else if (t.closest('#imp-exams-grid [data-exam]')) Exams.go(t.closest('[data-exam]').dataset.exam);
  });
  document.addEventListener('change', ev => { if (ev.target.id === 'imp-file') { check(ev.target.files[0]); ev.target.value = ''; } });
  // dropping a file anywhere on the Imported tab
  const tab = () => document.getElementById('home-page') && document.getElementById('home-page').dataset.tab === 'imported';
  document.addEventListener('dragover', ev => { if (tab() && ev.dataTransfer && [...ev.dataTransfer.types].includes('Files')) { ev.preventDefault(); const d = $1('imp-drop'); if (d) d.classList.add('over'); } });
  document.addEventListener('dragleave', ev => { if (ev.target.id === 'imp-drop' || !ev.relatedTarget) { const d = $1('imp-drop'); if (d) d.classList.remove('over'); } });
  document.addEventListener('drop', ev => {
    if (!tab() || !ev.dataTransfer || !ev.dataTransfer.files.length) return;
    ev.preventDefault();
    const d = $1('imp-drop'); if (d) d.classList.remove('over');
    check(ev.dataTransfer.files[0]);
  });

  // the first drawing (the lists are redrawn every time the home page is drawn: app.js renderHomePage)
  (async () => { await loadPacks(); renderLoad(); renderLists(); if (typeof Home !== 'undefined') Home.refresh(); })();
  return { refresh, packCount: () => packs.length, renderLists };
})();
