// The readiness view (#/readiness): how ready you are for the exam, per topic, and where one more hour pays most.
// It only looks at the exam material (the suggested path, path-data.js), never at the extra practice, and mixes four kinds of evidence:
//   practice  the path's exercises (warm-ups count a quarter), script ladders (x2) and script practice exams (x3), passed / total
//   quizzes   the theory quiz questions answered right, per topic
//   exams     the theory practice exams: the last answer to each question, per topic (GET /api/exams/stats)
// Each topic weighs what it weighs in the theory exams (tools/theory/exams/blueprint.json). The result is a coverage-weighted
// estimate of what you have mastered, not a prediction of the mark.
'use strict';
const Readiness = (() => {
  const $1 = id => document.getElementById(id);
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const TOPICS = {
    'shell-help': 'Shell & getting help', 'expansion-vars': 'Expansion, quoting & variables', 'files-fs': 'Files, directories & archives',
    permissions: 'Permissions', filters: 'Text filters', 'grep-regex': 'grep & regular expressions', find: 'find',
    'redirection-pipes': 'Redirection & pipes', scripts: 'Scripting', 'jobs-procs': 'Processes & jobs',
    'users-sessions': 'Users, groups & sessions', 'boot-systemd': 'Boot & systemd', 'logs-cron': 'Logs & cron',
  };
  // which topic an exercise / script / quiz feeds
  const EX_DIR = { '01': 'expansion-vars', '02': 'files-fs', '03': 'files-fs', '04': 'files-fs', '05': 'filters', '06': 'grep-regex', '07': 'find', '08': 'permissions',
    '09': 'redirection-pipes', '10': 'redirection-pipes', '11': 'expansion-vars', '12': 'jobs-procs', '13': 'scripts', '14': 'scripts', '15': 'scripts', '16': 'scripts',
    '17': 'users-sessions', '18': 'scripts', '20': 'shell-help' };
  const topicOfEx = e => { const t = EX_DIR[e.id.slice(0, 2)]; return t === 'users-sessions' && /auth\.log|cron|apache|log\b/i.test(e.title) ? 'logs-cron' : t; };
  const TAG_TOPIC = { arguments: 'scripts', 'exit codes': 'scripts', tests: 'scripts', loops: 'scripts', case: 'scripts', arithmetic: 'scripts', files: 'files-fs',
    'copy and move': 'files-fs', archives: 'files-fs', find: 'find', permissions: 'permissions', text: 'filters', pipes: 'redirection-pipes', logs: 'logs-cron' };
  const topicsOfScript = e => [...new Set((e.tags || []).map(t => TAG_TOPIC[t]).filter(Boolean))];
  const QUIZ_TOPIC = { '01_shell': 'shell-help', '02_processes': 'jobs-procs', '03_filesystem': 'files-fs', '04_permissions': 'permissions', '05_filters': 'filters',
    '06_grep_regex': 'grep-regex', '07_find': 'find', '08_expansion': 'expansion-vars', '09_redirection': 'redirection-pipes', '10_scripting_basics': 'scripts',
    '11_scripting_logic': 'scripts', '12_users_sessions': 'users-sessions', '13_boot_services': 'boot-systemd', '14_man_drills': 'shell-help' };
  const W = { warm: 0.25, ex: 1, sc: 2, sx: 3 };      // how much one practice item counts

  let stats = { weights: {}, topics: {}, missed: [], attempts: 0 };
  const load = async () => { try { stats = await (await fetch('/api/exams/stats')).json(); } catch { /* the page still works without exam data */ } };

  function compute() {
    const T = {};
    const keys = Object.keys(TOPICS), w0 = 1 / keys.length;
    for (const k of keys) T[k] = { key: k, name: TOPICS[k], weight: stats.weights[k] || (Object.keys(stats.weights).length ? 0 : w0), prac: { done: 0, total: 0, started: 0, n: 0, nDone: 0 }, quiz: { done: 0, total: 0 }, exam: { answered: 0, correct: 0 }, todo: [] };
    const addPrac = (t, w, it) => { const p = T[t] && T[t].prac; if (!p) return; p.total += w; p.n++; if (it.status === 'pass') { p.done += w; p.nDone++; } else if (it.status === 'part') p.started += w; if (it.status !== 'pass') T[t].todo.push(it); };
    for (const st of ExamPath.data) {
      for (const kind of ['warm', 'ex']) for (const id of st[kind] || []) {
        const it = ExamPath.item(kind, id), e = it && state.flat.find(x => x.id === id);
        if (it && e) addPrac(topicOfEx(e), W[kind], it);
      }
      for (const id of st.sc || []) { const it = ExamPath.item('sc', id), e = Scripts.entry(id); if (it && e) for (const t of topicsOfScript(e)) addPrac(t, W.sc, it); }
      for (const id of st.sx || []) { const it = ExamPath.item('sx', id); if (it) addPrac('scripts', W.sx, it); }
      for (const id of st.quiz || []) {
        const c = Theory.collection(id), t = QUIZ_TOPIC[id], it = ExamPath.item('quiz', id);
        if (!c || !T[t]) continue;
        const qs = c.groups.flatMap(g => g.questions);
        T[t].quiz.total += qs.length; T[t].quiz.done += qs.filter(q => q.status === 'pass').length;
        if (it && it.status !== 'pass') T[t].todo.push(it);
      }
    }
    for (const [k, v] of Object.entries(stats.topics || {})) if (T[k]) T[k].exam = v;
    const wsum = Object.values(T).reduce((s, t) => s + t.weight, 0) || 1;
    for (const t of Object.values(T)) {
      t.weight /= wsum;
      const parts = [];
      // nobody needs 100% of everything: covering 70% of the practice and quizzes, or answering 85% of the exam questions right, counts as full marks
      if (t.prac.total) parts.push([0.5, Math.min(1, t.prac.done / t.prac.total / 0.7)]);
      if (t.quiz.total) parts.push([0.15, Math.min(1, t.quiz.done / t.quiz.total / 0.7)]);
      if (t.exam.answered >= 3) parts.push([0.35, Math.min(1, t.exam.correct / t.exam.answered / 0.85)]);
      const ws = parts.reduce((s, p) => s + p[0], 0);
      t.mastery = ws ? parts.reduce((s, p) => s + p[0] * p[1], 0) / ws : 0;
      t.touched = t.prac.done + t.prac.started > 0 || t.quiz.done > 0 || t.exam.answered >= 3;
      t.level = !t.touched ? 'none' : t.mastery < 0.35 ? 'weak' : t.mastery < 0.7 ? 'mid' : 'strong';
      t.gap = t.weight * (1 - t.mastery);
    }
    const overall = Object.values(T).reduce((s, t) => s + t.weight * t.mastery, 0);
    return { T, list: Object.values(T), overall };
  }
  const LABEL = { none: 'Not started', weak: 'Weak', mid: 'Getting there', strong: 'Solid' };
  const pct = x => Math.round(100 * x);
  const evidence = t => [
    t.prac.n ? `exercises & scripts ${t.prac.nDone}/${t.prac.n}` : '',
    t.quiz.total ? `quizzes ${t.quiz.done}/${t.quiz.total}` : '',
    t.exam.answered ? `exams ${t.exam.correct}/${t.exam.answered} right` : 'no exam questions yet',
  ].filter(Boolean).join(' · ');
  const nextOf = t => t.todo[0] || null;
  const missedOf = k => (stats.missed || []).filter(m => m.topic === k);

  // ---------------------------------------------------------------- the page
  function renderPage() {
    const box = $1('readiness-content');
    if (!box) return;
    if (!state.flat || !state.flat.length) { box.innerHTML = '<p class="hint">Loading…</p>'; return; }
    const { list, overall } = compute();
    const focus = [...list].filter(t => t.gap > 0.002).sort((a, b) => b.gap - a.gap).slice(0, 3);
    const doneAll = ExamPath.stats();
    const exAcc = Object.values(stats.topics || {}).reduce((s, t) => [s[0] + t.correct, s[1] + t.answered], [0, 0]);
    box.innerHTML = `
      <section class="rd-top">
        <div class="rd-big"><span class="rd-num">${pct(overall)}%</span><span class="rd-cap">exam readiness</span></div>
        <div class="rd-facts">
          <div><b>${doneAll.done}</b> of ${doneAll.total} items of the suggested path done</div>
          <div><b>${exAcc[1] ? pct(exAcc[0] / exAcc[1]) + '%' : '—'}</b> right in theory practice exams ${exAcc[1] ? `(${exAcc[0]}/${exAcc[1]} questions, last answer of each)` : '(none taken yet)'}</div>
          <div class="hint">A coverage-weighted estimate of what you have practised, with every topic counting as much as it does in the theory exams. Not a prediction of your mark.</div>
        </div>
      </section>
      ${focus.length ? `<h2 class="rd-h">Focus next <span class="hint">— where the next hour pays most</span></h2>
      <section class="rd-focus">${focus.map(t => {
        const nx = nextOf(t), ms = missedOf(t.key);
        return `<article class="rd-card ${t.level}"><h3>${esc(t.name)}</h3>
          <div class="rd-line"><span class="rd-bar"><i style="width:${pct(t.mastery)}%"></i></span><b>${pct(t.mastery)}%</b><span class="rd-chip ${t.level}">${LABEL[t.level]}</span></div>
          <p class="hint">${esc(evidence(t))} · ${pct(t.weight)}% of the theory exams</p>
          <div class="rd-actions">${nx ? `<button type="button" class="hc-btn" data-rd="${esc(nx.kind)}:${esc(nx.id)}">Practise: ${esc(nx.label.length > 38 ? nx.label.slice(0, 37) + '…' : nx.label)} →</button>` : ''}
          ${ms.length ? `<button type="button" data-rd-miss="${esc(ms[0].exam)}:${ms[0].attempt}">Review ${ms.length} missed question${ms.length > 1 ? 's' : ''}</button>` : ''}</div></article>`;
      }).join('')}</section>` : '<p class="hint">Nothing to focus on: every topic is covered.</p>'}
      <h2 class="rd-h">All topics</h2>
      <table class="rd-table"><thead><tr><th>Topic</th><th>Exam weight</th><th>Readiness</th><th>Evidence</th><th></th></tr></thead><tbody>
      ${[...list].sort((a, b) => b.weight - a.weight).map(t => `<tr class="${t.level}">
        <td>${esc(t.name)}</td><td><span class="rd-bar w"><i style="width:${Math.min(100, pct(t.weight) * 6)}%"></i></span> ${pct(t.weight)}%</td>
        <td><span class="rd-bar"><i style="width:${pct(t.mastery)}%"></i></span> <b>${pct(t.mastery)}%</b> <span class="rd-chip ${t.level}">${LABEL[t.level]}</span></td>
        <td class="hint">${esc(evidence(t))}</td>
        <td>${nextOf(t) ? `<button type="button" class="small" data-rd="${esc(nextOf(t).kind)}:${esc(nextOf(t).id)}" title="${esc(nextOf(t).label)}">Practise</button>` : '<span class="hint">all done</span>'}</td></tr>`).join('')}
      </tbody></table>
      ${(stats.missed || []).length ? `<h2 class="rd-h">Missed in theory exams <span class="hint">— the last answer to these was wrong</span></h2>
      <ul class="rd-missed">${stats.missed.slice(0, 12).map(m => `<li><a href="#/exam/${esc(m.exam)}/attempt/${m.attempt}">${esc(m.title)}</a> <span class="hint">${esc(m.exam)} · ${esc(TOPICS[m.topic] || m.topic)}</span></li>`).join('')}</ul>` : ''}
      <details class="rd-how"><summary>How this is calculated</summary>
        <p>Only the material of the suggested path counts. Per topic, <b>practice</b> is the share of path exercises passed (warm-ups count a quarter, script ladders twice, script practice exams three times), <b>quizzes</b> the share of quiz questions answered right and <b>exams</b> the share of theory-exam questions whose last answer was right (at least 3 answered). Nobody needs 100% of everything, so passing 70% of the practice or the quizzes, or getting 85% of the exam questions right, counts as full marks for that part. The parts are mixed 50% / 15% / 35%, using only the kinds that exist for the topic, and the overall figure weighs the topics by their share of the theory-exam questions.</p>
      </details>`;
  }

  // ---------------------------------------------------------------- the card on the home page
  function renderCard() {
    const home = $1('home-body');
    if (!home || !state.flat || !state.flat.length) return;
    let card = $1('home-readiness');
    if (!card) {
      card = document.createElement('a');
      card.id = 'home-readiness'; card.className = 'home-readiness'; card.href = '#/readiness';
    }
    const { list, overall } = compute();
    const weak = [...list].filter(t => t.gap > 0.002).sort((a, b) => b.gap - a.gap).slice(0, 2);
    card.innerHTML = `<span class="rd-num small">${pct(overall)}%</span><span class="rd-cardtext"><b>Exam readiness</b>
      <span class="hint">${weak.length ? `Focus next: ${weak.map(t => esc(t.name)).join(', ')}` : 'Every topic is covered'} — see where you stand →</span></span>`;
    const before = $1('home-roadmap') || $1('home-grp-exercises');
    if (before && card.nextSibling !== before) home.insertBefore(card, before);
  }

  // ---------------------------------------------------------------- show / hide
  async function show(on) {
    $1('readiness-page').classList.toggle('hidden', !on);
    if (!on) return;
    document.title = 'Readiness — bash stash';
    renderPage();
    await load();
    if (!$1('readiness-page').classList.contains('hidden')) renderPage();
  }
  document.addEventListener('click', ev => {
    const p = ev.target.closest('#readiness-page [data-rd]');
    if (p) { const [k, ...id] = p.dataset.rd.split(':'); ExamPath.open(ExamPath.item(k, id.join(':'))); return; }
    const m = ev.target.closest('#readiness-page [data-rd-miss]');
    if (m) { const [ex, n] = m.dataset.rdMiss.split(':'); location.hash = `#/exam/${ex}/attempt/${n}`; }
  });
  if (typeof Home !== 'undefined' && Home.onRefresh) Home.onRefresh(() => { load().then(renderCard); renderCard(); });
  return { show, renderCard, compute, load };
})();
