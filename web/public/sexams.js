// bash stash — Script practice exams: ONE bash script per exam, graded out of 10 by objectives (pass at 5).
// Sources live in script-exams/<id>_<slug>/ (built from tools/src/script-exams/*.txt by tools/build_script_exams.js).
// An attempt: "Start" creates an empty script in .progress/script-exams/<id>/work/ and opens the terminal and VS Code there;
// "Submit" grades it on the server (bin/sgrade) and stores the result with the script itself. One setting (⚙) decides whether
// the checker may also be run during the attempt (practice) or only when submitting (exam-like: statement only, nothing else).
// An attempt in progress is kept until it is submitted or discarded; leaving never loses it.
'use strict';
const SExams = (() => {
  const STR = {
    en: {
      title: 'Practice exams', crumb: 'Script exam',
      intro: 'One bash script per exam, written in VS Code and the terminal only, graded out of 10 by objectives (pass at 5). Three levels, seven exams each. Settings (⚙) decide whether you can run the checker while you work or only when you submit. An unfinished attempt is kept: resume it or discard it from the exam\'s overview.',
      none: 'No script exams built yet (run <code>node tools/build_script_exams.js</code>).',
      tier_easy: 'Easy', tier_medium: 'Medium', tier_hard: 'Hard',
      passedCount: (p, t) => `${p}/${t} passed`, notTaken: 'Not attempted yet',
      bestLine: (b, n) => `Best ${b}/10 · ${n} attempt${n === 1 ? '' : 's'}`, lastLine: d => `Last: ${d}`, inProgress: 'In progress',
      meta: 'One script · graded out of 10 by objectives · pass at 5/10',
      chkSubmit: 'Checker: only on submit', chkAny: 'Checker: any time',
      settingsHint: 'Change this in Settings (⚙).',
      start: 'Start exam', resume: 'Resume attempt', discard: 'Discard it', retake: 'Retake exam', all: 'All exams', overview: 'Overview',
      discardConfirm: 'Discard the attempt in progress? Your script is archived but the attempt will not be graded.',
      draftLine: d => `Attempt in progress, started ${d}.`,
      objectives: 'Objectives', points: 'points',
      history: 'History', noHistory: 'No attempts yet. Your scores will show up here.',
      hN: '#', hWhen: 'When', hScore: 'Score', hTime: 'Time', hMode: 'Mode', review: 'Review',
      clear: 'Clear history', clearConfirm: 'Delete the history of this exam? This cannot be undone.',
      resultTitle: 'Result', passed: 'Passed', failed: 'Not passed', passLine: 'pass at 5/10', when: 'Finished', took: 'Time', mode: 'Mode',
      objTable: 'Score by objective', cases: (p, n) => `${p}/${n} checks`,
      report: 'Checker report', yourScript: 'Your script', showSolution: 'Show reference solution', hideSolution: 'Hide reference solution',
      solutionTitle: 'Reference solution',
      submit: 'Submit and grade', submitConfirm: 'Submit now? The script is graded and the attempt ends.', grading: '… grading',
      check: '▶ Check', checking: '… checking', quit: 'Back to overview', checkOff: 'The checker is off for this attempt: it grades only when you submit.',
      scriptLabel: 'script: ', runTitle: 'Practice exam', badge: 'Script exam: ',
      secs: s => s >= 60 ? `${Math.floor(s / 60)} min ${s % 60} s` : `${s} s`,
    },
    es: {
      title: 'Exámenes de práctica', crumb: 'Examen de script',
      intro: 'Un script de bash por examen, escrito solo con VS Code y el terminal, con nota sobre 10 por objetivos (aprobado en 5). Tres niveles, siete exámenes cada uno. Los ajustes (⚙) deciden si puedes ejecutar el corrector mientras trabajas o solo al entregar. Un intento sin terminar se conserva: puedes continuarlo o descartarlo desde la vista general del examen.',
      none: 'Todavía no hay exámenes de script (ejecuta <code>node tools/build_script_exams.js</code>).',
      tier_easy: 'Fácil', tier_medium: 'Medio', tier_hard: 'Difícil',
      passedCount: (p, t) => `${p}/${t} aprobados`, notTaken: 'Sin intentar',
      bestLine: (b, n) => `Mejor ${b}/10 · ${n} intento${n === 1 ? '' : 's'}`, lastLine: d => `Último: ${d}`, inProgress: 'En curso',
      meta: 'Un script · nota sobre 10 por objetivos · aprobado en 5/10',
      chkSubmit: 'Corrector: solo al entregar', chkAny: 'Corrector: en cualquier momento',
      settingsHint: 'Cámbialo en Ajustes (⚙).',
      start: 'Empezar examen', resume: 'Continuar intento', discard: 'Descartarlo', retake: 'Repetir examen', all: 'Todos los exámenes', overview: 'Vista general',
      discardConfirm: '¿Descartar el intento en curso? Tu script se archiva pero el intento no se corregirá.',
      draftLine: d => `Intento en curso, empezado ${d}.`,
      objectives: 'Objetivos', points: 'puntos',
      history: 'Historial', noHistory: 'Aún no hay intentos. Tus notas aparecerán aquí.',
      hN: '#', hWhen: 'Cuándo', hScore: 'Nota', hTime: 'Tiempo', hMode: 'Modo', review: 'Revisar',
      clear: 'Borrar historial', clearConfirm: '¿Borrar el historial de este examen? No se puede deshacer.',
      resultTitle: 'Resultado', passed: 'Aprobado', failed: 'No aprobado', passLine: 'aprobado en 5/10', when: 'Terminado', took: 'Tiempo', mode: 'Modo',
      objTable: 'Nota por objetivo', cases: (p, n) => `${p}/${n} pruebas`,
      report: 'Informe del corrector', yourScript: 'Tu script', showSolution: 'Mostrar la solución de referencia', hideSolution: 'Ocultar la solución de referencia',
      solutionTitle: 'Solución de referencia',
      submit: 'Entregar y corregir', submitConfirm: '¿Entregar ahora? Se corrige el script y termina el intento.', grading: '… corrigiendo',
      check: '▶ Comprobar', checking: '… comprobando', quit: 'Volver a la vista general', checkOff: 'El corrector está desactivado en este intento: solo corrige al entregar.',
      scriptLabel: 'script: ', runTitle: 'Examen de práctica', badge: 'Examen de script: ',
      secs: s => s >= 60 ? `${Math.floor(s / 60)} min ${s % 60} s` : `${s} s`,
    },
  };
  const curLang = () => { try { return localStorage.getItem('theoryLang') === 'es' ? 'es' : 'en'; } catch { return 'en'; } };
  const T = (k, ...a) => { const v = STR[curLang()][k] !== undefined ? STR[curLang()][k] : STR.en[k]; return typeof v === 'function' ? v(...a) : v; };
  const qLang = () => curLang() === 'en' ? '' : '?lang=es';
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const locale = () => curLang() === 'es' ? 'es-ES' : undefined;
  const fmtDate = iso => new Date(iso).toLocaleString(locale(), { dateStyle: 'medium', timeStyle: 'short' });
  const PASS = 5;
  const api = (p, opt) => fetch(`/api/sexams${p}`, opt);
  const post = (p, body) => api(p, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body || {}) });

  // ---------------------------------------------------------------- setting (⚙ menu)
  const getCheck = () => { try { return localStorage.getItem('sxCheck') === 'any' ? 'any' : 'submit'; } catch { return 'submit'; } };
  function syncSettingsUI() { Seg.set('sxcheck', getCheck()); }
  Seg.on('sxcheck', v => {
    try { localStorage.setItem('sxCheck', v === 'any' ? 'any' : 'submit'); } catch { /* private mode */ }
    syncSettingsUI();
    if (cur && cur.phase === 'intro' && !cur.d.attempt) render(true);   // an attempt in progress keeps the setting it started with
  });
  syncSettingsUI();

  // ---------------------------------------------------------------- data
  let index = [];
  let cur = null;        // { id, d (detail), attempts, phase: 'intro' | 'run' | 'result', review }
  async function load() {
    try { index = await (await api(qLang())).json(); } catch { index = []; }
    if (!Array.isArray(index)) index = [];
  }
  const list = () => index;
  const entry = id => index.find(e => e.id === id);
  const statusOf = e => e.best == null ? 'new' : e.best >= PASS ? 'pass' : 'attempted';
  const tierLabel = t => T('tier_' + t);
  async function refresh() { await load(); renderHomeGrid(); }

  // ---------------------------------------------------------------- home grid
  function renderHomeGrid() {
    $('#sexams-intro').textContent = T('intro');
    $('#home-sec-sexams').textContent = T('title');
    const grid = $('#sexams-grid');
    if (!index.length) { grid.innerHTML = `<p class="home-intro">${T('none')}</p>`; return; }
    const card = e => {
      const cls = e.best == null ? '' : e.best >= PASS ? 'good' : 'low';
      return `<button class="track-card exam-card${state.sexam === e.id ? ' current' : ''}" data-sexam="${esc(e.id)}">
        <div class="track-card-title">${esc(e.title)}</div>
        <div class="track-card-desc">${e.best == null ? T('notTaken') : `<span class="exam-best ${cls}">${T('bestLine', e.best, e.attempts)}</span>`}</div>
        <div class="track-card-count">${e.inProgress ? `<span class="exam-draft">${T('inProgress')}</span>` : e.last ? T('lastLine', `${e.last.score}/10 · ${fmtDate(e.last.finishedAt)}`) : '&nbsp;'}</div>
      </button>`;
    };
    grid.innerHTML = ['easy', 'medium', 'hard'].filter(t => index.some(e => e.tier === t)).map(t => {
      const es = index.filter(e => e.tier === t);
      return `<h3 class="home-tier-title">${T('tier_' + t)} <span>${T('passedCount', es.filter(e => statusOf(e) === 'pass').length, es.length)}</span></h3>
        <div class="track-grid exam-grid">${es.map(card).join('')}</div>`;
    }).join('');
  }
  $('#sexams-grid').addEventListener('click', ev => {
    const c = ev.target.closest('[data-sexam]');
    if (c) go(c.dataset.sexam);
  });
  const go = (id, sub) => { location.hash = `#/sexam/${id}${sub ? '/' + sub : ''}`; };

  // ---------------------------------------------------------------- panels
  const view = () => $('#exam-view');
  function showPanel() {          // overview / result live in the shared exam panel
    document.body.classList.remove('sexam-run', 'sexam-strict');
    $('#main').classList.add('hidden');
    $('#theory-main').classList.add('hidden');
    $('#exam-main').classList.remove('hidden');
    $('#sidebar').classList.add('exam-mode');
  }
  function hide() {
    document.body.classList.remove('sexam-run', 'sexam-strict');
    $('#exam-main').classList.add('hidden');
    $('#main').classList.remove('hidden');
    $('#sidebar').classList.remove('exam-mode');
    document.querySelector('.overall').title = 'exercises passed';
    requestAnimationFrame(() => { if (typeof fit !== 'undefined' && fit) try { fit.fit(); } catch { /* hidden */ } });
  }
  const visible = () => !$('#exam-main').classList.contains('hidden') && !!state.sexam || document.body.classList.contains('sexam-run');

  // ---------------------------------------------------------------- open
  async function fetchDetail(id) {
    const r = await api(`/${id}${qLang()}`);
    return r.ok ? r.json() : null;
  }
  async function open(id, mode, n) {
    if (!entry(id)) await load();
    if (!entry(id)) { location.replace('#/home'); return; }
    const [d, attempts] = await Promise.all([fetchDetail(id), api(`/${id}/attempts`).then(r => r.json())]);
    if (!d) { location.replace('#/home'); return; }
    if (!location.hash.startsWith(`#/sexam/${id}`)) return;       // navigated away while loading
    state.sexam = id; state.theory = null; state.exam = null;
    if (mode === 'run') {
      if (!d.attempt) { location.replace(`#/sexam/${id}`); return; }
      cur = { id, d, attempts, phase: 'run', review: null };
      return enterRun();
    }
    const att = n ? attempts.find(a => a.n === Number(n)) : null;
    cur = { id, d, attempts, phase: att ? 'result' : 'intro', review: att || null, solution: null };
    showPanel(); updateTrackBadge(); render();
  }
  async function onLang() {
    await load();
    renderHomeGrid();
    if (cur && state.sexam) {
      const d = await fetchDetail(cur.id);
      if (d) { cur.d = d; if (cur.phase === 'run') fillStatement(); else render(true); }
    }
    syncSettingsUI();
  }

  // ---------------------------------------------------------------- overview and result
  const modeLine = s => s && s.checkAnytime ? T('chkAny') : T('chkSubmit');
  const crumb = () => `${T('crumb')} · ${tierLabel(cur.d.tier)}`;
  function objectiveRows(objs, scored) {
    return objs.map(o => {
      const r = scored && scored.find(x => x.id === o.id);
      const pct = r && r.cases ? Math.round(100 * r.passed / r.cases) : 0;
      return `<tr><td>${esc(o.label)}</td><td>${scored ? `<b>${(r ? r.earned : 0).toFixed(1).replace(/\.0$/, '')}</b> / ${o.points}` : `${o.points} ${T('points')}`}</td>
        ${scored ? `<td><div class="sx-bar"><span style="width:${pct}%"></span></div><span class="hint">${r ? T('cases', r.passed, r.cases) : ''}</span></td>` : ''}</tr>`;
    }).join('');
  }
  function introHtml() {
    const d = cur.d, at = cur.attempts.slice().reverse(), c = d.attempt;
    const best = cur.attempts.length ? Math.max(...cur.attempts.map(a => a.score)) : null;
    const set = c ? c.settings : { checkAnytime: getCheck() === 'any' };
    const rows = at.map(a => `<tr><td>${a.n}</td><td>${esc(fmtDate(a.finishedAt))}</td>
      <td><span class="exam-best ${a.score >= PASS ? 'good' : 'low'}">${a.score}/10</span></td>
      <td>${esc(T('secs', a.seconds))}</td><td class="hint">${esc(modeLine(a.settings))}</td>
      <td><button class="small" data-act="review" data-n="${a.n}">${T('review')}</button></td></tr>`).join('');
    return `<div class="theory-head"><div>
        <div class="ex-topic">${esc(crumb())}</div><h1>${esc(d.title)}</h1>
        <div class="ex-meta"><span>${T('meta')} · <code>${esc(d.script)}</code></span></div></div>
        ${best == null ? '' : `<span class="badge ${best >= PASS ? 'pass' : 'attempted'}">${T('bestLine', best, cur.attempts.length)}</span>`}</div>
      <h2 class="ex-h2">${T('objectives')}</h2>
      <table class="ex-history sx-objectives"><tbody>${objectiveRows(d.objectives)}</tbody></table>
      <div class="ex-modes"><span class="ex-chip">${set.checkAnytime ? T('chkAny') : T('chkSubmit')}</span></div>
      ${c ? `<div class="ex-draft">${T('draftLine', esc(fmtDate(c.startedAt)))}</div>` : ''}
      <div class="th-actions">${c ? `<button class="primary" data-act="resume">${T('resume')}</button><button data-act="discard">${T('discard')}</button>`
        : `<button class="primary" data-act="start">${T('start')}</button>`}<a class="small-link" href="#/home">${T('all')}</a>${c ? '' : `<span class="hint">${T('settingsHint')}</span>`}</div>
      <h2 class="ex-h2">${T('history')}</h2>
      ${rows ? `<table class="ex-history"><thead><tr><th>${T('hN')}</th><th>${T('hWhen')}</th><th>${T('hScore')}</th><th>${T('hTime')}</th><th>${T('hMode')}</th><th></th></tr></thead><tbody>${rows}</tbody></table>
        <div class="th-actions"><button class="small" data-act="clear">${T('clear')}</button></div>` : `<p class="hint">${T('noHistory')}</p>`}`;
  }
  function resultHtml() {
    const a = cur.review, d = cur.d;
    return `<div class="theory-head"><div>
        <div class="ex-topic">${esc(crumb())} · ${esc(d.title)}</div><h1>${T('resultTitle')} · #${a.n}</h1></div></div>
      <div class="ex-result ${a.pass ? 'good' : 'low'}">
        <div class="ex-score">${a.score}<span>/10</span></div>
        <div><div class="ex-verdict">${a.pass ? T('passed') : T('failed')} <span class="hint">(${T('passLine')})</span></div>
        <div class="hint">${T('when')}: ${esc(fmtDate(a.finishedAt))} · ${T('took')}: ${esc(T('secs', a.seconds))}</div>
        <div class="hint">${T('mode')}: ${esc(modeLine(a.settings))}</div></div></div>
      <div class="th-actions"><button class="primary" data-act="retake">${T('retake')}</button>
        <button data-act="overview">${T('overview')}</button><a class="small-link" href="#/home">${T('all')}</a></div>
      <h2 class="ex-h2">${T('objTable')}</h2>
      <table class="ex-history sx-objectives"><tbody>${objectiveRows(d.objectives, a.objectives)}</tbody></table>
      <details class="sx-fold"${a.pass ? '' : ' open'}><summary>${T('report')}</summary><pre class="sx-pre">${esc(a.details || '')}</pre></details>
      <details class="sx-fold"><summary>${T('yourScript')}</summary><pre class="sx-pre">${esc(a.script || '')}</pre></details>
      <div class="th-actions"><button data-act="solution">${cur.solution ? T('hideSolution') : T('showSolution')}</button></div>
      ${cur.solution ? `<h2 class="ex-h2">${T('solutionTitle')}</h2><pre class="sx-pre">${esc(cur.solution)}</pre>` : ''}`;
  }
  function render(keepScroll) {
    if (!cur || cur.phase === 'run') return;
    view().innerHTML = cur.phase === 'result' ? resultHtml() : introHtml();
    document.title = `${cur.d.title} — ${T('crumb')} — bash stash`;
    if (!keepScroll) $('#exam-scroll').scrollTop = 0;
    renderSidebar();
  }
  function renderSidebar() {
    const nav = $('#topics');
    if (!cur) return;
    $('#sidebar').classList.add('exam-mode');
    document.querySelector('.overall').title = T('title');
    const scored = cur.phase === 'result' ? cur.review.objectives : null;
    nav.innerHTML = cur.d.objectives.map((o, i) => {
      const r = scored && scored.find(x => x.id === o.id);
      const st = !scored ? 'new' : r && r.passed === r.cases ? 'pass' : r && r.passed ? 'attempted' : 'new';
      return `<a class="ex-item ${st}"><span class="dot ${st}">${st === 'pass' ? '●' : st === 'attempted' ? '◐' : '○'}</span><span class="ex-id">${o.points}</span><span class="ex-name">${esc(o.label)}</span></a>`;
    }).join('');
  }
  view().addEventListener('click', async ev => {
    const b = ev.target.closest('[data-act]');
    if (!b || !cur || !state.sexam) return;
    const act = b.dataset.act;
    if (act === 'start' || act === 'retake') {
      b.disabled = true;
      await post(`/${cur.id}/start${qLang()}`, { settings: { checkAnytime: getCheck() === 'any' }, lang: curLang() });
      await refresh();
      go(cur.id, 'run');
    } else if (act === 'resume') go(cur.id, 'run');
    else if (act === 'discard') {
      if (!confirm(T('discardConfirm'))) return;
      await post(`/${cur.id}/discard`);
      await refresh(); cur.d = await fetchDetail(cur.id); render(true);
    } else if (act === 'overview') go(cur.id);
    else if (act === 'review') go(cur.id, 'attempt/' + b.dataset.n);
    else if (act === 'clear') {
      if (!confirm(T('clearConfirm'))) return;
      await post(`/${cur.id}/reset`);
      cur.attempts = []; await refresh(); render(true);
    } else if (act === 'solution') {
      if (cur.solution) cur.solution = null;
      else { const r = await post(`/${cur.id}/solution`); const j = await r.json(); cur.solution = j.content || j.error || ''; }
      render(true);
    }
  });

  // ---------------------------------------------------------------- the attempt (terminal + VS Code + statement)
  function fillStatement() {
    const d = cur.d;
    $('#ex-topic').textContent = `${T('runTitle')} · ${tierLabel(d.tier)}`;
    $('#ex-title').textContent = d.title;
    $('#ex-level').textContent = '';
    $('#ex-cmds').textContent = '';
    $('#ex-status').className = 'badge hidden';
    $('#answer-path').textContent = T('scriptLabel') + d.scriptPath.replace(/^\/home\/alumno\/lab\//, '');
    $('#readme').innerHTML = marked.parse(d.readme.replace(/^# .*\n+\*\*(?:Tier|Nivel):\*\*.*\n+/, ''));
    const any = d.attempt && d.attempt.settings.checkAnytime;
    $('#sx-check-btn').classList.toggle('hidden', !any);
    $('#sx-check-btn').textContent = T('check');
    $('#sx-submit-btn').textContent = T('submit');
    $('#sx-quit-btn').textContent = T('quit');
    $('#result').classList.add('hidden');
  }
  function enterRun() {
    const d = cur.d;
    state.current = { id: d.id, sx: true, title: d.title, level: 0, cmds: '', status: 'new', topic: T('runTitle'),
      dir: d.workDir, playDir: d.workDir, answer: d.scriptPath, readme: d.readme };
    state.activeVSCodeFile = null; state.codeFor = null;
    document.body.classList.add('sexam-run');
    document.body.classList.toggle('sexam-strict', !(d.attempt && d.attempt.settings.checkAnytime));   // exam-like: no Reference page either
    $('#exam-main').classList.add('hidden');
    $('#theory-main').classList.add('hidden');
    $('#main').classList.remove('hidden');
    fillStatement();
    $('#statement-pane').scrollTop = 0;
    document.title = `${d.title} — ${T('runTitle')} — bash stash`;
    updateTrackBadge();
    const layout = $('#main').dataset.layout || 'default';
    if (layout !== 'default' || state.mode === 'code') openVSCode();
    if (sock && sock.readyState === 1) sock.send(JSON.stringify({ t: 'i', d: `cd ${shq(d.workDir)} && clear && ls\r` }));
    requestAnimationFrame(() => { if (typeof fit !== 'undefined' && fit) try { fit.fit(); } catch { /* hidden */ } });
  }
  let busy = false;
  $('#sx-quit-btn').onclick = () => { if (cur) go(cur.id); };
  $('#sx-submit-btn').onclick = async () => {
    if (!cur || busy || cur.phase !== 'run' || !confirm(T('submitConfirm'))) return;
    busy = true;
    const btn = $('#sx-submit-btn');
    btn.disabled = true; btn.textContent = T('grading');
    try {
      const r = await post(`/${cur.id}/submit`);
      const j = await r.json();
      if (!r.ok) { alert(j.error || 'error'); return; }
      await refresh();
      go(cur.id, 'attempt/' + j.n);
    } finally { btn.disabled = false; btn.textContent = T('submit'); busy = false; }
  };
  $('#sx-check-btn').onclick = async () => {
    if (!cur || busy || cur.phase !== 'run') return;
    busy = true;
    const btn = $('#sx-check-btn'), box = $('#result'), body = $('#result-body');
    btn.disabled = true; btn.textContent = T('checking');
    box.classList.remove('hidden', 'pass', 'fail');
    $('#result-title').textContent = T('checking');
    const res = await CheckView.run(`/api/sexams/${cur.id}/check`, body);
    box.classList.add(res.code === '0' ? 'pass' : 'fail');
    $('#result-title').textContent = res.code === '0' ? '✔ OK' : '✘';
    CheckView.show(body, res);
    btn.disabled = false; btn.textContent = T('check'); busy = false;
  };

  return { load, list, entry, statusOf, open, hide, visible, onLang, refresh, renderHomeGrid, renderSidebar, go, t: T, tierLabel, current: () => cur };
})();
