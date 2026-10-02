// Home page: one thing at a time.
//   - four tabs: Start (hero, suggested path, the way into the rest), Coding exercises, Theory, Man drills; the page opens on Start
//   - Start has ONE primary button: "Start the suggested path" for a new user, "Continue" with the last item opened after that
//   - inside a tab every section can be folded to ONE row (progress bar, count, "next up" button); the choice is remembered, and the first section of a tab starts open
//   - the groups inside the Scripts and exam sections fold too (click their heading)
// This module also decides the order of the boxes on Start (hero, readiness, path, tiles); the others only fill their own box.
// It rebuilds nothing of what the other modules draw: it wraps their output and reads their data.
'use strict';
const Home = (() => {
  const SECS = [
    { key: 'tracks',  id: 'home-sec-tracks',      part: 'coding' },
    { key: 'intro',   id: 'home-sec-intro',       part: 'coding' },
    { key: 'scripts', id: 'home-sec-scripts',     part: 'coding' },
    { key: 'sexams',  id: 'home-sec-sexams',      part: 'coding' },
    { key: 'quizzes', id: 'theory-quizzes-title', part: 'theory' },
    { key: 'exams',   id: 'theory-exams-title',   part: 'theory' },
    { key: 'man',     id: 'home-sec-man',         part: 'man' },
  ];
  const TABS = [['start', 'Start'], ['coding', 'Coding exercises'], ['theory', 'Theory'], ['man', 'Man drills']];
  const GROUP_TAB = { 'home-grp-exercises': 'coding', 'theory-home-title': 'theory', 'man-home-title': 'man' };   // the group headings (sidebar labels) -> their tab
  const DEFAULT_OPEN = ['tracks', 'quizzes', 'man'];   // the first section of each tab (a tab with one folded row looks empty)
  const el = id => document.getElementById(id);
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const store = {
    get(k, d) { try { const v = JSON.parse(localStorage.getItem(k)); return v == null ? d : v; } catch { return d; } },
    set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch { /* private mode */ } },
  };

  // ---------------------------------------------------------------- folding sections
  const collapsedMap = () => store.get('homeSecCollapsed', {});
  const isCollapsed = key => { const m = collapsedMap(); return key in m ? !!m[key] : !DEFAULT_OPEN.includes(key); };
  function setCollapsed(key, on) {
    const m = collapsedMap(); m[key] = !!on; store.set('homeSecCollapsed', m);
    apply();
  }
  const secEl = key => document.querySelector(`.home-sec[data-sec="${key}"]`);
  function wrap() {
    for (const s of SECS) {
      const h = el(s.id);
      if (!h || h.parentElement.classList.contains('home-sec')) continue;
      const sec = document.createElement('section'), summary = document.createElement('div'), inner = document.createElement('div');
      sec.className = 'home-sec'; sec.dataset.sec = s.key; sec.dataset.part = s.part;
      summary.className = 'home-sec-summary'; inner.className = 'home-sec-body';
      h.parentNode.insertBefore(sec, h);
      sec.append(h, summary, inner);
      for (let n = sec.nextSibling; n && !(n.nodeType === 1 && /^H[12]$/.test(n.tagName));) { const nx = n.nextSibling; inner.appendChild(n); n = nx; }
      h.setAttribute('role', 'button'); h.tabIndex = 0;
      h.addEventListener('click', () => setCollapsed(s.key, !isCollapsed(s.key)));
      h.addEventListener('keydown', ev => { if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); setCollapsed(s.key, !isCollapsed(s.key)); } });
      summary.addEventListener('click', ev => {
        if (ev.target.closest('.hs-go')) return nextOf(s.key) && nextOf(s.key).run();
        setCollapsed(s.key, false);
      });
    }
  }
  function apply() {
    for (const s of SECS) {
      const sec = secEl(s.key), h = el(s.id);
      if (!sec) continue;
      const c = isCollapsed(s.key);
      sec.classList.toggle('collapsed', c);
      h.setAttribute('aria-expanded', String(!c));
    }
  }
  // sidebar / keyboard jumps to a section show its contents
  function expandById(headId) {
    const s = SECS.find(x => x.id === headId);
    setTab(s ? s.part : GROUP_TAB[headId] || tab, false);
    if (s && isCollapsed(s.key)) setCollapsed(s.key, false);
  }

  // ---------------------------------------------------------------- the tabs
  let tab = 'start', ready = false;   // (the sidebar asks this module for the tab, so it cannot be redrawn while the module is still loading)
  const page = () => el('home-page');
  function setTab(t, toTop = true) {
    if (!TABS.some(x => x[0] === t)) t = 'start';
    const changed = t !== tab;
    tab = t;
    const p = page(); if (p) p.dataset.tab = t;
    if (changed || toTop) {
      renderBar();
      if (ready) renderHomeNav();   // the sidebar lists the tab that is open
    }
    if (toTop) { const b = el('home-body'); if (b) b.scrollTop = 0; }
  }
  const tabOfGroup = grp => GROUP_TAB[grp] || 'coding';

  // ---------------------------------------------------------------- what each section knows about progress
  const intro = () => (state.index || []).filter(t => t.id !== '18' && t.id !== '19' && t.id !== '20').flatMap(t => t.exercises.filter(e => e.tier === 0).map(e => ({ e, t })));
  const stepOf = e => (e.steps.find(s => !e.passed.includes(s.n)) || e.steps[e.steps.length - 1]).n;
  const DATA = {
    tracks() {
      const pool = typeof visibleFlat === 'function' ? visibleFlat() : [];
      const next = pool.find(e => e.status !== 'pass');
      return { done: pool.filter(e => e.status === 'pass').length, total: pool.length, what: `${TRACK_LABELS[state.track] || state.track} track`,
        next: next && { label: `${next.id} · ${next.title}`, run: () => selectTrack(state.track, next.id) } };
    },
    intro() {
      const all = intro(), next = all.find(x => x.e.status !== 'pass');
      return { done: all.filter(x => x.e.status === 'pass').length, total: all.length,
        next: next && { label: `${next.e.id} · ${next.e.title}`, run: () => selectIntroCategory(next.t.id, next.e.id) } };
    },
    scripts() {
      const all = Scripts.list(), next = all.find(e => e.status !== 'pass');
      return { done: all.filter(e => e.status === 'pass').length, total: all.length,
        next: next && { label: `${next.id.slice(1)} · ${next.title}`, run: () => Scripts.go(next.id, stepOf(next)) } };
    },
    sexams() {
      const all = SExams.list(), next = all.find(e => SExams.statusOf(e) !== 'pass');
      return { done: all.filter(e => SExams.statusOf(e) === 'pass').length, total: all.length, next: next && { label: next.title, run: () => SExams.go(next.id) } };
    },
    quizzes() {
      const all = Theory.list().filter(c => !c.ws), qs = all.flatMap(c => c.groups.flatMap(g => g.questions)), next = all.find(c => c.groups.some(g => g.questions.some(q => q.status !== 'pass')));
      return { done: qs.filter(q => q.status === 'pass').length, total: qs.length, unit: 'questions', next: next && { label: next.title, run: () => Theory.go(next.id) } };
    },
    man() {
      const qs = manQuizzes().flatMap(c => c.groups.flatMap(g => g.questions)), tasks = manTasks();
      const nq = manQuizzes().find(c => c.groups.some(g => g.questions.some(q => q.status !== 'pass'))), nt = tasks.find(e => e.status !== 'pass');
      const next = nq ? { label: nq.title, run: () => Theory.go(nq.id) } : nt ? { label: `${nt.id} · ${nt.title}`, run: () => selectTrack('man', nt.id) } : null;
      return { done: qs.filter(q => q.status === 'pass').length + tasks.filter(e => e.status === 'pass').length, total: qs.length + tasks.length, unit: 'questions and tasks', next };
    },
    exams() {
      const all = Exams.list(), next = all.find(e => Exams.statusOf(e) !== 'pass');
      return { done: all.filter(e => Exams.statusOf(e) === 'pass').length, total: all.length, next: next && { label: next.title, run: () => Exams.go(next.id) } };
    },
  };
  const hooks = [];
  const cache = {};
  const nextOf = key => (cache[key] || {}).next;
  function refreshSummaries() {
    for (const s of SECS) {
      let d;
      try { d = DATA[s.key](); } catch { d = null; }
      cache[s.key] = d;
      const sec = secEl(s.key);
      if (!sec || !d) continue;
      const pct = d.total ? 100 * d.done / d.total : 0;
      sec.querySelector('.home-sec-summary').innerHTML = `<span class="hs-bar"><i style="width:${pct}%"></i></span>
        <span class="hs-count">${d.done}/${d.total} ${d.unit || 'done'}</span>
        ${d.next ? `<span class="hs-next">Next up: <b>${esc(d.next.label)}</b></span><button class="hs-go small" type="button">Go</button>`
                 : `<span class="hs-next">${d.total ? 'Everything here is done.' : ''}</span>`}
        <span class="hs-more">Show ▾</span>`;
    }
    renderBar();
    renderHero();
    renderTiles();
    hooks.forEach(fn => { try { fn(); } catch { /* a hook must not break the page */ } });
    arrange();
  }

  // ---------------------------------------------------------------- the tab bar (sticky)
  function renderBar() {
    let bar = el('home-minibar');
    if (!bar) {
      bar = document.createElement('nav');
      bar.id = 'home-minibar'; bar.className = 'home-minibar'; bar.setAttribute('role', 'tablist'); bar.setAttribute('aria-label', 'Home');
      el('home-body').prepend(bar);
      bar.addEventListener('click', ev => { const b = ev.target.closest('[data-tab]'); if (b) setTab(b.dataset.tab); });
    }
    bar.innerHTML = TABS.map(([k, label]) => {
      const d = tabStats(k);
      return `<button type="button" role="tab" data-tab="${k}" aria-selected="${k === tab}"${k === tab ? ' class="active"' : ''}>${esc(label)}${d && d.done ? ` <i>${d.done}/${d.total}</i>` : ''}</button>`;
    }).join('');
  }
  // what a tab (and its tile on Start) counts: exercises and scripts, quiz questions, man questions and tasks
  function tabStats(k) {
    const c = cache;
    if (k === 'coding') {
      const pool = (state.flat || []).filter(e => e.tier > 0 && e.tier < 4);
      const parts = [c.intro, c.scripts, c.sexams].filter(Boolean);
      return { done: pool.filter(e => e.status === 'pass').length + parts.reduce((n, d) => n + d.done, 0), total: pool.length + parts.reduce((n, d) => n + d.total, 0),
        text: `${pool.length} exercises · ${c.intro ? c.intro.total : 0} warm-ups · ${c.scripts ? c.scripts.total : 0} scripts · ${c.sexams ? c.sexams.total : 0} script exams` };
    }
    if (k === 'theory') {
      const q = c.quizzes, e = c.exams;
      return q && e && { done: q.done + e.done, total: q.total + e.total, text: `${q.total} quiz questions · ${e.total} practice exams` };
    }
    if (k === 'man') return c.man && { done: c.man.done, total: c.man.total, text: `${c.man.total} questions and tasks` };
    return null;
  }

  // ---------------------------------------------------------------- the hero: the one thing to do next
  const LAST = 'homeLastOpen';
  function remember() {
    const m = location.hash.match(/^#\/(ex|script|sexam|exam|theory)\/([\w.-]+)(?:\/([\w-]+))?/);
    if (!m) return;
    let h = `#/${m[1]}/${m[2]}`;
    if (m[1] === 'theory' && m[3]) h += '/' + m[3];
    if (m[1] === 'script' && m[3] && /^\d+$/.test(m[3])) h += '/' + m[3];
    store.set(LAST, h);
  }
  const STATUS_TXT = { pass: 'passed', attempted: 'in progress', viewed: 'solution viewed', new: 'not started' };
  function describe(h) {
    const m = h && h.match(/^#\/(ex|script|sexam|exam|theory)\/([\w.-]+)(?:\/([\w-]+))?/);
    if (!m) return null;
    const [, kind, id, sub] = m;
    if (kind === 'ex') {
      const e = (state.flat || []).find(x => x.id === id), t = e && state.index.find(x => x.exercises.includes(e));
      return e && { kind: 'Exercise', title: `${e.id} · ${e.title}`, sub: t ? t.title : '', status: e.status };
    }
    if (kind === 'script') {
      const e = Scripts.entry(id);
      return e && { kind: 'Script', title: `${id.slice(1)} · ${e.title}`, sub: `step ${sub || stepOf(e)} of ${e.steps.length}`, status: e.status };
    }
    if (kind === 'sexam') { const e = SExams.entry(id); return e && { kind: 'Script practice exam', title: e.title, sub: SExams.tierLabel(e.tier), status: SExams.statusOf(e) }; }
    if (kind === 'exam') { const e = Exams.entry(id); return e && { kind: 'Theory practice exam', title: e.title, sub: Exams.tierLabel(e.tier), status: Exams.statusOf(e) }; }
    const c = Theory.collection(id);
    if (!c) return null;
    const q = sub && c.groups.flatMap(g => g.questions).find(x => x.id === sub);
    return { kind: 'Quiz', title: c.title, sub: q ? q.title : '', status: q ? q.status : 'new' };
  }
  const isFresh = () => !(state.flat || []).some(e => e.status === 'pass') && !Scripts.list().some(e => e.status === 'pass');
  function renderHero() {
    if (!state.flat || !state.flat.length) return;
    let box = el('home-hero');
    if (!box) {
      box = document.createElement('div');
      box.id = 'home-hero'; box.className = 'home-hero';
      el('home-body').insertBefore(box, el('home-grp-exercises'));
      box.addEventListener('click', ev => {
        const b = ev.target.closest('[data-act]');
        if (!b) return;
        const act = b.dataset.act;
        if (b.tagName === 'A') ev.preventDefault();
        if (act === 'path') { const n = ExamPath.next(null); if (n) ExamPath.open(n); }
        else if (act === 'tour') NewUser.startTour();
        else if (act === 'hide') { store.set('startHidden', true); renderHero(); }
        else if (act === 'go') location.hash = b.dataset.go;
      });
    }
    el('home-body').classList.toggle('fresh', isFresh());
    const nx = ExamPath.next(null), last = store.get(LAST, null), d = describe(last);
    if (isFresh() && !store.get('startHidden', false)) {
      box.className = 'home-hero fresh';
      box.innerHTML = `<h2>Learn bash for the exam, one small step at a time</h2>
        <p>Each exercise gives you a task, a terminal and a Check button. The suggested path lists everything the exam needs, in order, starting with tiny warm-ups.</p>
        <div class="hs-actions"><button class="hc-btn" type="button" data-act="path">Start the suggested path →</button>
          <button type="button" data-act="tour">Take the 1-minute tour</button><button type="button" class="linklike" data-act="hide">I know my way around — hide this</button></div>
        <details class="hero-how"><summary>How an exercise works</summary><ol>
          <li><b>Read the task</b> on the left, then write your answer in <code>answer.sh</code> with the terminal or VS Code (they edit the same file).</li>
          <li><b>Press Check</b> (<kbd>Ctrl</kbd> <kbd>Enter</kbd>). If it fails you see what differed and can try your script on the same files.</li>
          <li><b>Stuck?</b> <i>Info</i> explains the commands, the <i>Reference</i> (<kbd>Ctrl</kbd> <kbd>K</kbd>) is the full manual, and <i>Show solution</i> is the last resort.</li></ol></details>`;
      return;
    }
    const pathLink = nx && (!d || nx.hash !== last) ? `<a href="${esc(nx.hash)}" class="hero-alt" data-act="path">or the next item of the suggested path: <b>${esc(nx.label)}</b></a>` : '';
    if (d) {
      box.className = 'home-hero';
      box.innerHTML = `<div class="hc-kind">Continue where you left off</div><div class="hc-title">${esc(d.title)}</div>
        <div class="hc-sub">${esc(d.kind)}${d.sub ? ' · ' + esc(d.sub) : ''} · ${STATUS_TXT[d.status] || ''}</div>
        <div class="hs-actions"><button class="hc-btn" type="button" data-act="go" data-go="${esc(last)}">Continue →</button>${pathLink}</div>`;
    } else if (nx) {
      box.className = 'home-hero';
      box.innerHTML = `<div class="hc-kind">${isFresh() ? 'Start here' : 'Next on the suggested path'}</div><div class="hc-title">${esc(nx.label)}</div>
        <div class="hs-actions"><button class="hc-btn" type="button" data-act="path">${isFresh() ? 'Start' : 'Continue'} →</button></div>`;
    } else { box.className = 'home-hero hidden'; box.innerHTML = ''; }
  }

  // ---------------------------------------------------------------- the tiles: the way into the rest
  function renderTiles() {
    let box = el('home-tiles');
    if (!box) {
      box = document.createElement('div');
      box.id = 'home-tiles'; box.className = 'home-tiles';
      el('home-body').insertBefore(box, el('home-grp-exercises'));
      box.addEventListener('click', ev => {
        const t = ev.target.closest('[data-tab]');
        if (t) setTab(t.dataset.tab);
      });
    }
    const fresh = isFresh();
    const tile = (k, title, desc) => {
      const d = tabStats(k);
      if (!d) return '';
      return `<button type="button" class="home-tile" data-tab="${k}"><span class="ht-title">${esc(title)}</span><span class="ht-desc">${esc(desc)}</span>
        ${fresh ? '' : `<span class="hs-bar"><i style="width:${d.total ? 100 * d.done / d.total : 0}%"></i></span>`}
        <span class="ht-stat">${fresh ? esc(d.text) : `${d.done}/${d.total} done`}</span></button>`;
    };
    const n = (window.MANUAL && MANUAL.all) ? MANUAL.all().length : 0;
    box.innerHTML = `<h2 class="home-sub">Or choose what to practise</h2><div class="home-tile-grid">
      ${tile('coding', 'Coding exercises', 'Write bash in a real terminal and press Check: tracks, warm-ups, whole scripts and script exams.')}
      ${tile('theory', 'Theory', 'Quizzes on the concepts behind the commands, and theory practice exams.')}
      ${tile('man', 'Man page drills', 'Train with the only help the exam allows: the manual.')}
      <a class="home-tile" href="#/reference"><span class="ht-title">Reference</span><span class="ht-desc">Every command and concept, grouped by topic and searchable.</span><span class="ht-stat">${n ? n + ' entries' : ''}</span></a></div>`;
  }
  // the order of the boxes on Start, whoever drew them
  function arrange() {
    const body = el('home-body'), h1 = el('home-grp-exercises');
    if (!body || !h1) return;
    let ref = h1;
    for (const id of ['home-tiles', 'home-roadmap', 'home-readiness', 'home-hero']) {
      const e = el(id);
      if (!e) continue;
      if (e.nextElementSibling !== ref) body.insertBefore(e, ref);
      ref = e;
    }
  }

  // ---------------------------------------------------------------- folding the groups inside a section (Scripts: stars/topics, exams: tiers)
  const groupKey = h => `${h.closest('.home-sec') ? h.closest('.home-sec').dataset.sec : '?'}:${h.firstChild ? h.firstChild.textContent.trim() : ''}`;
  function applyGroups(root) {
    const folded = store.get('homeGroupsFolded', []);
    root.querySelectorAll('.home-tier-title').forEach(h => {
      const on = folded.includes(groupKey(h)), grid = h.nextElementSibling;
      h.classList.toggle('folded', on);
      h.setAttribute('role', 'button'); h.tabIndex = 0; h.setAttribute('aria-expanded', String(!on));
      if (grid && grid.classList.contains('track-grid')) grid.classList.toggle('home-folded', on);
    });
  }
  function toggleGroup(h) {
    const k = groupKey(h), folded = store.get('homeGroupsFolded', []), i = folded.indexOf(k);
    if (i >= 0) folded.splice(i, 1); else folded.push(k);
    store.set('homeGroupsFolded', folded);
    applyGroups(h.closest('.home-sec-body') || h.parentElement);
  }

  // ---------------------------------------------------------------- start
  function init() {
    if (!el('home-body')) return;
    wrap();
    apply();
    page().dataset.tab = 'start';
    const body = el('home-body');
    body.addEventListener('click', ev => { const h = ev.target.closest('.home-tier-title'); if (h) toggleGroup(h); });
    body.addEventListener('keydown', ev => { const h = ev.target.closest && ev.target.closest('.home-tier-title'); if (h && (ev.key === 'Enter' || ev.key === ' ')) { ev.preventDefault(); toggleGroup(h); } });
    // the other modules redraw their grids when their data arrives: follow them
    let timer = 0;
    const later = () => { clearTimeout(timer); timer = setTimeout(refreshSummaries, 60); };
    for (const id of ['track-grid', 'intro-grid', 'scripts-grid', 'sexams-grid', 'theory-grid', 'exams-grid']) {
      const g = el(id);
      if (!g) continue;
      new MutationObserver(() => { applyGroups(g); later(); }).observe(g, { childList: true });
      applyGroups(g);
    }
    // the section titles are retranslated with the Theory language
    for (const s of SECS) { const h = el(s.id); if (h) new MutationObserver(later).observe(h, { childList: true, characterData: true, subtree: true }); }
    el('home-topics').addEventListener('click', ev => { const o = ev.target.closest('[data-scroll]'); if (o && !ev.target.closest('.ex-item')) expandById(o.dataset.scroll); }, true);
    window.addEventListener('hashchange', remember);
    remember();
    later();
  }
  init();
  ready = true;
  return { refresh: refreshSummaries, expandById, apply, onRefresh: fn => hooks.push(fn), setTab, tab: () => tab, tabOfGroup, onShow: () => setTab('start') };
})();
