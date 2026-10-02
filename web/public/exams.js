// bash stash — Practice exams (sets of 10 single-choice questions, 1 point each, no penalty).
// Sets live in theory/exams/<id>.json (compiled from tools/theory/exams/*.txt by tools/build_theory.js).
// Two independent settings (⚙) decide how an attempt behaves:
//   Validation  "each" -> every answer is checked and explained right away (practice); an answered question is locked
//               "end"   -> nothing is revealed until the exam is finished (exam experience)
//   Going back  allowed -> move to earlier questions (with validation at the end you may also change their answers;
//                          with validation after each question you can re-read their explanations)
//               not allowed -> strictly sequential: a question is final once you move on
// An attempt in progress is saved on the server as you go (one per set): leaving never loses it, and it can be resumed
// or discarded from the exam's overview. Each finished attempt is sent to the server, which recomputes the score and
// keeps the history (.progress/exams/<id>.json). Picks are stored as the option's index in the SOURCE order, so history
// reviews and resumed attempts work in either language.
'use strict';
const Exams = (() => {
  // ---------------------------------------------------------------- language (shared with Theory)
  const STR = {
    en: {
      title: 'Practice exams', crumb: 'Practice exam',
      intro: 'Mock exams of 10 single-choice questions, 1 point each and no penalty for wrong answers. Settings (⚙) let you choose when answers are checked and whether you can go back, to resemble the real exam. An attempt you leave is kept so you can resume it, and every finished attempt is saved in the history of its set, with the date and the score.',
      none: 'No practice exams built yet (run <code>node tools/build_theory.js exams</code>).',
      tier_easy: 'Easy', tier_medium: 'Medium', tier_hard: 'Hard', tier_imported: 'Imported',
      passedCount: (p, t) => `${p}/${t} passed`, notTaken: 'Not attempted yet',
      bestLine: (b, n) => `Best ${b}/10 · ${n} attempt${n === 1 ? '' : 's'}`, lastLine: d => `Last: ${d}`,
      meta: n => `${n} questions · 1 point each · no penalty · pass at 5/10`,
      fbEach: 'Validation after each question', fbEnd: 'Validation at the end',
      backYes: 'Going back allowed', backNo: 'No going back',
      settingsHint: 'Change these in Settings (⚙).', start: 'Start exam', retake: 'Retake exam', all: 'All exams', overview: 'Overview',
      resume: 'Resume attempt', discard: 'Discard it', discardConfirm: 'Discard the attempt in progress? Its answers will be lost.',
      draftLine: (pos, total, d) => `Attempt in progress: question ${pos} of ${total}, last saved ${d}.`, inProgress: (pos, total) => `In progress · question ${pos}/${total}`,
      history: 'History', noHistory: 'No attempts yet. Your scores will show up here.',
      hN: '#', hWhen: 'Date', hScore: 'Score', hTime: 'Time', hMode: 'Mode', review: 'Review', clear: 'Clear history',
      clearConfirm: t => `Delete the attempt history of "${t}"?`,
      questionN: n => `Question ${n}`, counter: (n, m) => `Question ${n} of ${m}`,
      check: 'Check answer', skip: 'Skip', next: 'Next →', skipNext: 'Skip →', finish: 'Finish exam', prevTitle: 'Previous question (←)',
      hintEach: 'Press 1–4 to pick, Enter to check', hintNext: 'Press Enter for the next question', hintEnd: 'Press 1–4 to pick, Enter for the next question',
      scoreSoFar: (s, n) => `Score ${s}/${n}`, answeredOf: (a, n) => `${a}/${n} answered`,
      correct: '✔ Correct', notQuite: '✘ Not quite', skipped: '— Skipped',
      pickedRight: '✔ Correct answer — your pick', missedOne: '✔ This was the correct answer',
      pickedWrong: '✘ Wrong — your pick', notCorrect: '✘ Not correct',
      unanswered: n => `${n} question${n === 1 ? ' is' : 's are'} unanswered and will score 0. Finish anyway?`,
      saveFailed: 'Could not save the attempt. Check that the server is running and try Finish again.',
      resultTitle: 'Result', passed: 'Passed', failed: 'Not passed', passLine: 'pass mark 5/10',
      took: 'Time', when: 'Finished', mode: 'Mode', topicsMissed: 'Topics to revisit',
      qCorrect: 'Correct', qWrong: 'Wrong', qUnanswered: 'Unanswered', yourPick: 'your answer',
      topics: { 'shell-help': 'Shell basics & help', 'jobs-procs': 'Jobs & processes', 'files-fs': 'Files & filesystems', permissions: 'Permissions',
        filters: 'Filters', 'grep-regex': 'grep & regex', find: 'find', 'expansion-vars': 'Expansion & variables',
        'redirection-pipes': 'Redirection & pipes', scripts: 'Scripts', 'users-sessions': 'Users & sessions',
        'boot-systemd': 'Boot & systemd', 'logs-cron': 'Logs & cron' },
      badge: 'Exam: ', search: 'Search…',
    },
    es: {
      title: 'Exámenes de práctica', crumb: 'Examen de práctica',
      intro: 'Simulacros de 10 preguntas de respuesta única, 1 punto cada una y sin penalización por fallar. Los ajustes (⚙) permiten elegir cuándo se corrigen las respuestas y si se puede volver atrás, para parecerse al examen real. Un intento que abandonas se conserva para continuarlo, y cada intento terminado queda guardado en el historial de su examen, con la fecha y la nota.',
      none: 'Aún no hay exámenes de práctica (ejecuta <code>node tools/build_theory.js exams</code>).',
      tier_easy: 'Fácil', tier_medium: 'Medio', tier_hard: 'Difícil', tier_imported: 'Importado',
      passedCount: (p, t) => `${p}/${t} aprobados`, notTaken: 'Sin intentar',
      bestLine: (b, n) => `Mejor ${b}/10 · ${n} intento${n === 1 ? '' : 's'}`, lastLine: d => `Último: ${d}`,
      meta: n => `${n} preguntas · 1 punto cada una · sin penalización · aprobado con 5/10`,
      fbEach: 'Corrección tras cada pregunta', fbEnd: 'Corrección al final',
      backYes: 'Se puede volver atrás', backNo: 'Sin volver atrás',
      settingsHint: 'Cámbialo en Ajustes (⚙).', start: 'Empezar examen', retake: 'Repetir examen', all: 'Todos los exámenes', overview: 'Resumen',
      resume: 'Continuar intento', discard: 'Descartarlo', discardConfirm: '¿Descartar el intento en curso? Se perderán sus respuestas.',
      draftLine: (pos, total, d) => `Intento en curso: pregunta ${pos} de ${total}, guardado por última vez ${d}.`, inProgress: (pos, total) => `En curso · pregunta ${pos}/${total}`,
      history: 'Historial', noHistory: 'Aún no hay intentos. Tus notas aparecerán aquí.',
      hN: 'N.º', hWhen: 'Fecha', hScore: 'Nota', hTime: 'Tiempo', hMode: 'Modo', review: 'Revisar', clear: 'Borrar historial',
      clearConfirm: t => `¿Borrar el historial de intentos de «${t}»?`,
      questionN: n => `Pregunta ${n}`, counter: (n, m) => `Pregunta ${n} de ${m}`,
      check: 'Comprobar', skip: 'Saltar', next: 'Siguiente →', skipNext: 'Saltar →', finish: 'Terminar examen', prevTitle: 'Pregunta anterior (←)',
      hintEach: 'Pulsa 1–4 para elegir e Intro para comprobar', hintNext: 'Pulsa Intro para la siguiente pregunta', hintEnd: 'Pulsa 1–4 para elegir e Intro para la siguiente pregunta',
      scoreSoFar: (s, n) => `Nota ${s}/${n}`, answeredOf: (a, n) => `${a}/${n} respondidas`,
      correct: '✔ Correcto', notQuite: '✘ No del todo', skipped: '— Saltada',
      pickedRight: '✔ Respuesta correcta — tu elección', missedOne: '✔ Esta era la respuesta correcta',
      pickedWrong: '✘ Incorrecta — tu elección', notCorrect: '✘ Incorrecta',
      unanswered: n => `${n} pregunta${n === 1 ? ' está' : 's están'} sin responder y puntuará${n === 1 ? '' : 'n'} 0. ¿Terminar igualmente?`,
      saveFailed: 'No se pudo guardar el intento. Comprueba que el servidor funciona y pulsa Terminar otra vez.',
      resultTitle: 'Resultado', passed: 'Aprobado', failed: 'Suspenso', passLine: 'aprobado con 5/10',
      took: 'Tiempo', when: 'Terminado', mode: 'Modo', topicsMissed: 'Temas para repasar',
      qCorrect: 'Correcta', qWrong: 'Incorrecta', qUnanswered: 'Sin responder', yourPick: 'tu respuesta',
      topics: { 'shell-help': 'Shell y ayuda', 'jobs-procs': 'Trabajos y procesos', 'files-fs': 'Ficheros y sistemas de ficheros', permissions: 'Permisos',
        filters: 'Filtros', 'grep-regex': 'grep y regex', find: 'find', 'expansion-vars': 'Expansiones y variables',
        'redirection-pipes': 'Redirecciones y tuberías', scripts: 'Scripts', 'users-sessions': 'Usuarios y sesiones',
        'boot-systemd': 'Arranque y systemd', 'logs-cron': 'Logs y cron' },
      badge: 'Examen: ', search: 'Buscar…',
    },
  };
  const curLang = () => { try { return localStorage.getItem('theoryLang') === 'es' ? 'es' : 'en'; } catch { return 'en'; } };
  const T = (k, ...a) => { const v = STR[curLang()][k] !== undefined ? STR[curLang()][k] : STR.en[k]; return typeof v === 'function' ? v(...a) : v; };
  const qLang = () => curLang() === 'en' ? '' : '?lang=es';
  const md = s => marked.parse(s || '');
  const mdi = s => marked.parseInline(s || '');
  const tag = (cls, text) => `<span class="th-tag ${cls}">${text}</span>`;
  const topicName = t => (STR[curLang()].topics || {})[t] || t;
  const locale = () => curLang() === 'es' ? 'es-ES' : undefined;
  const fmtDate = iso => new Date(iso).toLocaleString(locale(), { dateStyle: 'medium', timeStyle: 'short' });
  const fmtDur = s => s >= 60 ? `${Math.floor(s / 60)} min ${s % 60} s` : `${s} s`;
  function shuffle(a) {
    const r = a.slice();
    for (let i = r.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [r[i], r[j]] = [r[j], r[i]]; }
    return r;
  }

  // ---------------------------------------------------------------- settings (⚙ menu)
  function getSettings() {
    let fb = 'each', back = true;
    try { fb = localStorage.getItem('examFeedback') === 'end' ? 'end' : 'each'; back = localStorage.getItem('examBack') !== '0'; } catch { /* private mode */ }
    return { feedback: fb, back };
  }
  function syncSettingsUI() {
    const s = getSettings();
    Seg.set('feedback', s.feedback);
    $('#exam-back').checked = s.back;
  }
  Seg.on('feedback', v => {
    try { localStorage.setItem('examFeedback', v === 'end' ? 'end' : 'each'); } catch { /* private mode */ }
    afterSettings();
  });
  $('#exam-back').onchange = ev => {
    try { localStorage.setItem('examBack', ev.target.checked ? '1' : '0'); } catch { /* private mode */ }
    afterSettings();
  };
  function afterSettings() {
    syncSettingsUI();
    if (cur && cur.phase === 'intro' && !cur.draft) render(true);   // an attempt in progress keeps the settings it started with
  }

  // ---------------------------------------------------------------- data
  let index = [];        // light list from /api/exams (stats per set)
  const cache = {};      // id + lang -> full exam
  let cur = null;        // { id, exam, attempts, draft, phase: 'intro'|'run'|'result', run, review }
  const PASS = 5;
  async function load() {
    try { index = await (await fetch('/api/exams' + qLang())).json(); } catch { index = []; }
    if (!Array.isArray(index)) index = [];
  }
  const list = () => index.filter(e => !e.imp);          // the course material; imported packs have their own tab
  const imported = () => index.filter(e => e.imp);
  const entry = id => index.find(e => e.id === id);
  const statusOf = e => e.best == null ? 'new' : e.best >= PASS ? 'pass' : 'attempted';
  async function fetchExam(id) {
    const k = id + curLang();
    if (!cache[k]) { try { cache[k] = await (await fetch(`/api/exams/${id}${qLang()}`)).json(); } catch { return null; } }
    return cache[k];
  }
  async function fetchAttempts(id) {
    try { const a = await (await fetch(`/api/exams/${id}/attempts`)).json(); return Array.isArray(a) ? a : []; } catch { return []; }
  }
  const fetchDraft = async id => {
    try { const d = await (await fetch(`/api/exams/${id}/draft`)).json(); return d && Array.isArray(d.answers) ? d : null; } catch { return null; }
  };
  async function refreshIndex() {
    await load();
    renderHomeGrid();
    if (typeof renderHomeNav === 'function') renderHomeNav();
  }

  // An attempt in progress is saved as it goes (server side), so leaving the page never loses it:
  // it can be resumed or discarded from the exam's overview.
  let saveTimer = null, saving = Promise.resolve();
  function saveDraft(now) {
    if (!cur || cur.phase !== 'run') return;
    clearTimeout(saveTimer);
    const id = cur.id, r = cur.run;
    const send = () => {
      const body = JSON.stringify({ startedAt: r.startedAt, settings: r.settings, pos: r.pos, order: r.order, answers: r.answers, revealed: r.revealed, locked: r.locked });
      saving = saving.then(() => fetch(`/api/exams/${id}/draft`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body, keepalive: true })).catch(() => {});
    };
    if (now) send(); else saveTimer = setTimeout(send, 250);
  }
  function allowRoute() { if (cur && cur.phase === 'run') saveDraft(true); return true; }   // nothing to confirm: the attempt is kept

  // ---------------------------------------------------------------- home page
  function applyStatic() {
    $('#theory-exams-title').textContent = T('title');
    $('#theory-exams-intro').textContent = T('intro');
  }
  const card = e => {
    const cls = e.best == null ? '' : e.best >= PASS ? 'good' : 'low';
    return `<button class="track-card exam-card${state.exam === e.id ? ' current' : ''}" data-exam="${esc(e.id)}">
      <div class="track-card-title">${esc(e.title)}</div>
      <div class="track-card-desc">${e.best == null ? T('notTaken') : `<span class="exam-best ${cls}">${T('bestLine', e.best, e.attempts)}</span>`}</div>
      <div class="track-card-count">${e.draft ? `<span class="exam-draft">${T('inProgress', e.draft.pos + 1, e.draft.total)}</span>` : e.last ? T('lastLine', `${e.last.score}/${e.last.total} · ${fmtDate(e.last.finishedAt)}`) : '&nbsp;'}</div>
    </button>`;
  };
  function renderHomeGrid() {
    applyStatic();
    const grid = $('#exams-grid');
    if (!index.length) { grid.innerHTML = `<p class="home-intro">${T('none')}</p>`; return; }
    grid.innerHTML = ['easy', 'medium', 'hard'].filter(t => index.some(e => e.tier === t)).map(t => {
      const es = index.filter(e => e.tier === t);
      return `<h3 class="home-tier-title">${T('tier_' + t)} <span>${T('passedCount', es.filter(e => statusOf(e) === 'pass').length, es.length)}</span></h3>
        <div class="track-grid exam-grid">${es.map(card).join('')}</div>`;
    }).join('');
  }
  $('#exams-grid').addEventListener('click', ev => {
    const c = ev.target.closest('[data-exam]');
    if (c) go(c.dataset.exam);
  });
  const go = (id, n) => { location.hash = `#/exam/${id}${n ? '/attempt/' + n : ''}`; };

  // ---------------------------------------------------------------- panel show / hide
  const view = () => $('#exam-view');
  function show() {
    $('#main').classList.add('hidden');
    $('#theory-main').classList.add('hidden');
    $('#exam-main').classList.remove('hidden');
    $('#sidebar').classList.add('exam-mode');
  }
  function hide() {
    $('#exam-main').classList.add('hidden');
    $('#main').classList.remove('hidden');
    $('#sidebar').classList.remove('exam-mode');
    document.querySelector('.overall').title = 'exercises passed';
    requestAnimationFrame(() => { if (typeof fit !== 'undefined' && fit) try { fit.fit(); } catch { /* hidden */ } });
  }
  const visible = () => !$('#exam-main').classList.contains('hidden');

  // ---------------------------------------------------------------- open
  async function open(id, n) {
    if (!entry(id)) { location.replace('#/home'); return; }
    await saving;                                  // let a pending save of the attempt we just left land first
    const [exam, attempts, draft] = await Promise.all([fetchExam(id), fetchAttempts(id), fetchDraft(id)]);
    if (!exam || !exam.questions) { location.replace('#/home'); return; }
    if (!location.hash.startsWith(`#/exam/${id}`)) return;   // navigated away while loading
    state.exam = id; state.theory = null;
    const att = n ? attempts.find(a => a.n === Number(n)) : null;
    cur = { id, exam, attempts, draft, phase: att ? 'result' : 'intro', run: null, review: att || null };
    show(); updateTrackBadge(); render();
  }
  async function onLang() {   // Settings → Theory language changed
    for (const k of Object.keys(cache)) delete cache[k];
    await load();
    renderHomeGrid();
    if (cur) { const e = await fetchExam(cur.id); if (e && e.questions) cur.exam = e; if (visible()) render(true); }
  }

  // ---------------------------------------------------------------- rendering
  function render(keepScroll) {
    if (!cur) return;
    view().innerHTML = cur.phase === 'run' ? runHtml() : cur.phase === 'result' ? resultHtml() : introHtml();
    document.title = `${cur.exam.title} — ${T('crumb')} — bash stash`;
    if (!keepScroll) $('#exam-scroll').scrollTop = 0;
    renderSidebar();
    saveDraft();
  }
  const modeLine = s => `${s.feedback === 'each' ? T('fbEach') : T('fbEnd')} · ${s.back ? T('backYes') : T('backNo')}`;
  const crumb = () => `${T('crumb')} · ${T('tier_' + cur.exam.tier)}`;

  function introHtml() {
    const e = cur.exam, d = cur.draft, s = d ? d.settings : getSettings(), at = cur.attempts.slice().reverse();
    const best = cur.attempts.length ? Math.max(...cur.attempts.map(a => a.score)) : null;
    const rows = at.map(a => `<tr>
      <td>${a.n}</td><td>${esc(fmtDate(a.finishedAt))}</td>
      <td><span class="exam-best ${a.score >= PASS ? 'good' : 'low'}">${a.score}/${a.total}</span></td>
      <td>${esc(fmtDur(a.seconds))}</td><td class="hint">${esc(modeLine(a.settings))}</td>
      <td><button class="small" data-act="review" data-n="${a.n}">${T('review')}</button></td></tr>`).join('');
    return `<section class="home-hero ex-hero"><div class="theory-head"><div>
        <div class="ex-topic">${esc(crumb())}</div><h1>${esc(e.title)}</h1>
        <div class="ex-meta"><span>${T('meta', e.questions.length)}</span></div></div>
        ${best == null ? '' : `<span class="badge ${best >= PASS ? 'pass' : 'attempted'}">${T('bestLine', best, cur.attempts.length)}</span>`}</div>
      <article class="readme th-question">${md(e.about)}</article>
      <div class="ex-modes"><span class="ex-chip">${s.feedback === 'each' ? T('fbEach') : T('fbEnd')}</span><span class="ex-chip">${s.back ? T('backYes') : T('backNo')}</span></div>
      ${d ? `<div class="ex-draft">${T('draftLine', d.pos + 1, e.questions.length, esc(fmtDate(d.savedAt)))}</div>` : ''}
      <div class="th-actions">${d ? `<button class="primary" data-act="resume">${T('resume')}</button><button data-act="discard">${T('discard')}</button>`
        : `<button class="primary" data-act="start">${T('start')}</button>`}<a class="small-link" href="#/home">${T('all')}</a>${d ? '' : `<span class="hint">${T('settingsHint')}</span>`}</div></section>
      <h2 class="ex-h2">${T('history')}</h2>
      ${rows ? `<table class="ex-history"><thead><tr><th>${T('hN')}</th><th>${T('hWhen')}</th><th>${T('hScore')}</th><th>${T('hTime')}</th><th>${T('hMode')}</th><th></th></tr></thead><tbody>${rows}</tbody></table>
        <div class="th-actions"><button class="small" data-act="clear">${T('clear')}</button></div>`
        : `<p class="hint">${T('noHistory')}</p>`}`;
  }

  function runHtml() {
    const r = cur.run, e = cur.exam, i = r.pos, n = e.questions.length, q = e.questions[i], s = r.settings, last = i === n - 1;
    const rev = r.revealed[i], picked = r.answers[i], locked = rev || r.locked[i];
    const opts = r.order[i].map((src, k) => {
      const o = q.options[src];
      let cls = '', why = '';
      if (rev) {
        const right = o.ok, p = picked === src;
        cls = right ? (p ? 'right' : 'missed') : (p ? 'wrong' : 'rejected');
        const label = right ? (p ? T('pickedRight') : T('missedOne')) : (p ? T('pickedWrong') : T('notCorrect'));
        why = `<span class="th-why">${tag(cls, label)} ${mdi(o.why)}</span>`;
      }
      return `<label class="th-opt ${cls}" data-i="${src}">
        <input type="radio" name="ex-opt"${picked === src ? ' checked' : ''}${locked ? ' disabled' : ''}>
        <span class="th-mark"></span><span class="th-opt-main"><span class="th-opt-text">${mdi(o.t)}</span>${why}</span><kbd>${k + 1}</kbd></label>`;
    }).join('');
    let fb = '';
    if (rev) {
      const ok = picked != null && q.options[picked].ok;
      fb = `<div class="th-feedback ${picked == null ? '' : ok ? 'good' : 'bad'}" id="ex-feedback" aria-live="polite">
        <div class="th-verdict">${picked == null ? T('skipped') : ok ? T('correct') : T('notQuite')}</div>
        ${q.note ? `<div class="th-note">${md(q.note)}</div>` : ''}</div>`;
    }
    const btn = (act, label, cls = '', dis = false, title = '') =>
      `<button class="${cls}" data-act="${act}"${dis ? ' disabled' : ''}${title ? ` title="${esc(title)}"` : ''}>${label}</button>`;
    let actions = '';
    if (s.feedback === 'each') {
      actions = (s.back ? btn('prev', '←', '', i === 0, T('prevTitle')) : '') + (!rev ? btn('check', T('check'), 'primary', picked == null) + btn('skip', T('skip'))
        : last ? btn('finish', T('finish'), 'primary') : btn('next', T('next'), 'primary'));
    } else if (s.back) {
      actions = btn('prev', '←', '', i === 0, T('prevTitle')) + btn('next', T('next'), last ? '' : 'primary', last) + btn('finish', T('finish'), last ? 'primary' : '');
    } else {
      actions = last ? btn('finish', T('finish'), 'primary') : btn('next', picked == null ? T('skipNext') : T('next'), 'primary');
    }
    const done = r.revealed.filter(Boolean).length;
    const score = r.answers.filter((a, j) => r.revealed[j] && a != null && e.questions[j].options[a].ok).length;
    const badge = s.feedback === 'each'
      ? `<span class="badge${done ? (score * 2 >= done ? ' pass' : ' attempted') : ''}">${T('scoreSoFar', score, done)}</span>`
      : `<span class="badge">${T('answeredOf', r.answers.filter(a => a != null).length, n)}</span>`;
    return `<div class="theory-head"><div>
        <div class="ex-topic">${esc(crumb())} · ${esc(e.title)}</div><h1>${T('counter', i + 1, n)}</h1>
        <div class="ex-meta"><span>${esc(modeLine(s))}</span></div></div>${badge}</div>
      <article class="readme th-question">${md(q.text)}</article>
      <div class="th-body" id="ex-opts">${opts}</div>
      <div class="th-actions">${actions}<span class="hint">${s.feedback === 'each' ? (rev ? T('hintNext') : T('hintEach')) : T('hintEnd')}</span></div>${fb}`;
  }

  function resultHtml() {
    const a = cur.review, e = cur.exam;
    const byQ = q => a.answers.find(x => x.q === q.id) || { pick: null, ok: false };
    const wrongTopics = [...new Set(e.questions.filter(q => !byQ(q).ok).map(q => q.topic).filter(Boolean))];
    const items = e.questions.map((q, i) => {
      const ans = byQ(q), st = ans.ok ? 'pass' : ans.pick == null ? 'new' : 'attempted';
      const label = ans.ok ? T('qCorrect') : ans.pick == null ? T('qUnanswered') : T('qWrong');
      const opts = q.options.map((o, idx) => {
        const p = ans.pick === idx, right = o.ok;
        const cls = right ? (p ? 'right' : 'missed') : (p ? 'wrong' : 'rejected');
        const lab = right ? (p ? T('pickedRight') : T('missedOne')) : (p ? T('pickedWrong') : T('notCorrect'));
        return `<div class="th-opt ${cls}"><span class="th-mark"></span><span class="th-opt-main"><span class="th-opt-text">${mdi(o.t)}</span>
          <span class="th-why">${tag(cls, lab)} ${mdi(o.why)}</span></span></div>`;
      }).join('');
      return `<details class="ex-rq ${st}" id="ex-rq-${i}"${ans.ok ? '' : ' open'}>
        <summary><span class="dot ${st}">${STATUS[st].dot}</span><b>${T('questionN', i + 1)}</b> · ${esc(q.title)}
          <span class="hint">${esc(topicName(q.topic))}</span><span class="ex-rq-state ${st}">${label}</span></summary>
        <article class="readme th-question">${md(q.text)}</article>${opts}
        ${q.note ? `<div class="th-note">${md(q.note)}</div>` : ''}</details>`;
    }).join('');
    return `<div class="theory-head"><div>
        <div class="ex-topic">${esc(crumb())} · ${esc(e.title)}</div><h1>${T('resultTitle')} · #${a.n}</h1></div></div>
      <div class="ex-result ${a.pass ? 'good' : 'low'}">
        <div class="ex-score">${a.score}<span>/${a.total}</span></div>
        <div><div class="ex-verdict">${a.pass ? T('passed') : T('failed')} <span class="hint">(${T('passLine')})</span></div>
        <div class="hint">${T('when')}: ${esc(fmtDate(a.finishedAt))} · ${T('took')}: ${esc(fmtDur(a.seconds))}</div>
        <div class="hint">${T('mode')}: ${esc(modeLine(a.settings))}</div>
        ${wrongTopics.length ? `<div class="hint">${T('topicsMissed')}: ${wrongTopics.map(t => esc(topicName(t))).join(' · ')}</div>` : ''}</div></div>
      <div class="th-actions"><button class="primary" data-act="retake">${T('retake')}</button>
        <button data-act="overview">${T('overview')}</button><a class="small-link" href="#/home">${T('all')}</a></div>
      <div class="ex-review">${items}</div>`;
  }

  // ---------------------------------------------------------------- sidebar (the exam's questions)
  function renderSidebar() {
    const nav = $('#topics');
    if (!cur) return;
    $('#sidebar').classList.add('exam-mode');
    document.querySelector('.overall').title = T('title');
    const n = cur.exam.questions.length;
    let rows = '', answered = 0;
    for (let i = 0; i < n; i++) {
      let st = 'new', here = false, click = '';
      if (cur.phase === 'run') {
        const r = cur.run, q = cur.exam.questions[i];
        here = r.pos === i;
        if (r.answers[i] != null) answered++;
        if (r.revealed[i]) st = r.answers[i] != null && q.options[r.answers[i]].ok ? 'pass' : 'attempted';
        else if (r.answers[i] != null) st = 'viewed';   // answered, not revealed (exam mode): a neutral mark
        // with validation after each question only the questions already checked (and the current one) can be revisited
        click = r.settings.back && (r.settings.feedback === 'end' || r.revealed[i] || here) ? ' data-go="1"' : '';
      } else if (cur.phase === 'result') {
        const q = cur.exam.questions[i], a = cur.review.answers.find(x => x.q === q.id);
        st = a && a.ok ? 'pass' : a && a.pick != null ? 'attempted' : 'new';
        click = ' data-go="1"';
        answered++;
      }
      rows += `<a class="ex-item${here ? ' current' : ''}${click ? '' : ' static'}" href="#" data-q="${i}"${click}>
        <span class="dot ${st}">${STATUS[st].dot}</span><span class="ex-id">${i + 1}</span><span class="ex-name">${T('questionN', i + 1)}</span></a>`;
    }
    nav.innerHTML = `<div class="ex-side-title">${esc(cur.exam.title)}</div>${rows}`;
    nav.dataset.theoryFor = '';
    $('#overall-fill').style.width = `${100 * answered / n}%`;
    $('#overall-text').textContent = cur.phase === 'intro' ? `0/${n}` : `${answered}/${n}`;
  }
  $('#topics').addEventListener('click', ev => {
    const a = ev.target.closest('.ex-item[data-q]');
    if (!a || !state.exam || !cur) return;
    ev.preventDefault();
    if (!a.dataset.go) return;
    const i = Number(a.dataset.q);
    if (cur.phase === 'run') { cur.run.pos = i; render(); }
    else if (cur.phase === 'result') {
      const d = document.getElementById(`ex-rq-${i}`);
      if (d) { d.open = true; d.scrollIntoView({ block: 'start', behavior: 'smooth' }); }
    }
  });

  // ---------------------------------------------------------------- attempt flow
  function startAttempt() {
    const e = cur.exam, n = e.questions.length;
    cur.run = {
      startedAt: new Date().toISOString(), settings: getSettings(), pos: 0,
      // options are shuffled per attempt, except a pinned one ("None of the above"), which stays last
      order: e.questions.map(q => {
        const idx = q.options.map((_, i) => i);
        return [...shuffle(idx.filter(i => !q.options[i].pin)), ...idx.filter(i => q.options[i].pin)];
      }),
      answers: Array(n).fill(null), revealed: Array(n).fill(false), locked: Array(n).fill(false),
    };
    cur.phase = 'run'; cur.review = null; cur.draft = null;
    render();
  }
  function resume() {
    const d = cur.draft;
    if (!d) return;
    cur.run = { startedAt: d.startedAt, settings: d.settings, pos: d.pos, order: d.order, answers: d.answers, revealed: d.revealed, locked: d.locked };
    cur.phase = 'run'; cur.review = null; cur.draft = null;
    render();
  }
  function check() {
    const r = cur.run, i = r.pos;
    if (r.settings.feedback !== 'each' || r.revealed[i] || r.answers[i] == null) return;
    r.revealed[i] = true;
    render(true);
    const fb = document.getElementById('ex-feedback');
    if (fb) fb.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
  }
  function skip() {
    const r = cur.run, i = r.pos;
    if (r.settings.feedback !== 'each' || r.revealed[i]) return;
    r.answers[i] = null; r.revealed[i] = true;
    render(true);
  }
  function step(d) {
    const r = cur.run, n = cur.exam.questions.length, to = r.pos + d;
    if (to < 0 || to >= n) return;
    if (d < 0 && !r.settings.back) return;
    if (d > 0 && r.settings.feedback === 'each' && !r.revealed[r.pos]) return;     // check (or skip) first
    if (!r.settings.back) r.locked[r.pos] = true;                                  // no going back: this question is final
    r.pos = to;
    render();
  }
  async function finish() {
    const r = cur.run, e = cur.exam;
    if (r.settings.feedback === 'each' && !r.revealed[r.pos]) return;
    const blank = r.answers.filter(a => a == null).length;
    if (r.settings.feedback === 'end' && blank && !confirm(T('unanswered', blank))) return;
    clearTimeout(saveTimer);
    await saving;
    const body = {
      startedAt: r.startedAt, finishedAt: new Date().toISOString(), settings: r.settings, lang: curLang(),
      answers: e.questions.map((q, i) => ({ q: q.id, pick: r.answers[i] })),
    };
    let att;
    try {
      const res = await fetch(`/api/exams/${cur.id}/attempts`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
      att = await res.json();
      if (!res.ok || !att || typeof att.score !== 'number') throw new Error('bad response');
    } catch { alert(T('saveFailed')); return; }
    cur.attempts.push(att);
    cur.run = null; cur.phase = 'result'; cur.review = att; cur.draft = null;   // the server dropped the draft with the attempt
    go(cur.id, att.n);                       // #/exam/<id>/attempt/<n>: the result has its own address
    refreshIndex();
  }
  function pick(src) {
    const r = cur && cur.run;
    if (!r) return;
    const i = r.pos;
    if (r.revealed[i] || r.locked[i]) return;
    r.answers[i] = src;
    render(true);
  }

  view().addEventListener('click', async ev => {
    const lab = ev.target.closest('label.th-opt[data-i]');
    if (lab && cur && cur.phase === 'run') { ev.preventDefault(); pick(Number(lab.dataset.i)); return; }
    const b = ev.target.closest('[data-act]');
    if (!b || !cur) return;
    const act = b.dataset.act;
    if (act === 'start' || act === 'retake') startAttempt();
    else if (act === 'resume') resume();
    else if (act === 'discard') {
      if (!confirm(T('discardConfirm'))) return;
      await saving;
      await fetch(`/api/exams/${cur.id}/draft/delete`, { method: 'POST' });
      cur.draft = null; render(true);
      refreshIndex();
    }
    else if (act === 'check') check();
    else if (act === 'skip') skip();
    else if (act === 'next') step(1);
    else if (act === 'prev') step(-1);
    else if (act === 'finish') finish();
    else if (act === 'review') go(cur.id, b.dataset.n);
    else if (act === 'overview') { cur.phase = 'intro'; cur.review = null; location.hash = `#/exam/${cur.id}`; }
    else if (act === 'clear') {
      if (!confirm(T('clearConfirm', cur.exam.title))) return;
      await fetch(`/api/exams/${cur.id}/reset`, { method: 'POST' });
      cur.attempts = [];
      await refreshIndex();
      render(true);
    }
  });

  document.addEventListener('keydown', ev => {
    if (!state.exam || !cur || cur.phase !== 'run' || !visible() || ev.ctrlKey || ev.metaKey || ev.altKey) return;
    const r = cur.run, i = r.pos;
    if (/^[1-4]$/.test(ev.key)) { const src = r.order[i][Number(ev.key) - 1]; if (src !== undefined) pick(src); return; }
    if (ev.key === 'Enter') {
      if (ev.target.matches && ev.target.matches('button, a')) return;   // let a focused button act
      ev.preventDefault();
      const last = i === cur.exam.questions.length - 1;
      if (r.settings.feedback === 'each') { if (!r.revealed[i]) check(); else if (last) finish(); else step(1); }
      else if (last) finish(); else step(1);
    } else if (ev.key === 'ArrowRight') step(1);
    else if (ev.key === 'ArrowLeft') step(-1);
  });

  syncSettingsUI();
  applyStatic();
  const refresh = async () => { await saving; await refreshIndex(); };   // the home page shows fresh scores and drafts
  return { load, list, entry, statusOf, open, hide, visible, allowRoute, onLang, refresh, renderHomeGrid, renderSidebar, go, t: T, imported, cardHTML: card,
    current: () => (state.exam && cur ? cur.id : null), tierLabel: t => T('tier_' + t) };
})();
