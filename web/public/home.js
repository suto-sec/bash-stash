// Home page browsing: less scrolling.
//   - every section can be folded to ONE row (progress bar, count, "next up" button); the choice is remembered, and only Tracks starts open
//   - the groups inside the Scripts and exam sections fold too (click their heading)
//   - a sticky bar with a jump chip (and the progress) of every section
//   - a "Continue where you left off" card at the top: the last thing opened and the next exercise of the current track
// It rebuilds nothing of what the other modules draw: it wraps their output and reads their data.
'use strict';
const Home = (() => {
  const SECS = [
    { key: 'tracks',  id: 'home-sec-tracks',      part: 'Coding' },
    { key: 'intro',   id: 'home-sec-intro',       part: 'Coding' },
    { key: 'scripts', id: 'home-sec-scripts',     part: 'Coding' },
    { key: 'sexams',  id: 'home-sec-sexams',      part: 'Coding' },
    { key: 'quizzes', id: 'theory-quizzes-title', part: 'Theory' },
    { key: 'exams',   id: 'theory-exams-title',   part: 'Theory' },
  ];
  const DEFAULT_OPEN = ['tracks'];
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
      sec.className = 'home-sec'; sec.dataset.sec = s.key;
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
    if (s && isCollapsed(s.key)) setCollapsed(s.key, false);
  }

  // ---------------------------------------------------------------- what each section knows about progress
  const intro = () => (state.index || []).filter(t => t.id !== '18' && t.id !== '19').flatMap(t => t.exercises.filter(e => e.tier === 0).map(e => ({ e, t })));
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
      const all = Theory.list(), qs = all.flatMap(c => c.groups.flatMap(g => g.questions)), next = all.find(c => c.groups.some(g => g.questions.some(q => q.status !== 'pass')));
      return { done: qs.filter(q => q.status === 'pass').length, total: qs.length, unit: 'questions', next: next && { label: next.title, run: () => Theory.go(next.id) } };
    },
    exams() {
      const all = Exams.list(), next = all.find(e => Exams.statusOf(e) !== 'pass');
      return { done: all.filter(e => Exams.statusOf(e) === 'pass').length, total: all.length, next: next && { label: next.title, run: () => Exams.go(next.id) } };
    },
  };
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
    renderContinue();
  }

  // ---------------------------------------------------------------- the sticky bar
  function renderBar() {
    let bar = el('home-minibar');
    if (!bar) {
      bar = document.createElement('nav');
      bar.id = 'home-minibar'; bar.className = 'home-minibar'; bar.setAttribute('aria-label', 'Sections');
      el('home-body').prepend(bar);
      bar.addEventListener('click', ev => {
        const b = ev.target.closest('[data-sec]');
        if (!b) return;
        setCollapsed(b.dataset.sec, false);
        const h = el(SECS.find(s => s.key === b.dataset.sec).id);
        h.scrollIntoView({ block: 'start' });
      });
    }
    let html = '', part = null;
    for (const s of SECS) {
      const h = el(s.id), d = cache[s.key];
      if (!h) continue;
      if (s.part !== part) { html += `<span class="mb-part">${s.part}</span>`; part = s.part; }
      html += `<button type="button" data-sec="${s.key}">${esc(h.textContent)}${d ? ` <i>${d.done}/${d.total}</i>` : ''}</button>`;
    }
    bar.innerHTML = html;
    syncBar();
  }
  function syncBar() {
    const body = el('home-body'), bar = el('home-minibar');
    if (!body || !bar) return;
    const y = body.scrollTop + 110;
    let cur = null;
    for (const s of SECS) { const h = el(s.id); if (h && h.offsetParent && h.offsetTop <= y) cur = s.key; }
    bar.querySelectorAll('button').forEach(b => b.classList.toggle('active', b.dataset.sec === cur));
  }

  // ---------------------------------------------------------------- "continue where you left off"
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
  function renderContinue() {
    let box = el('home-continue');
    if (!box) {
      box = document.createElement('div');
      box.id = 'home-continue'; box.className = 'home-continue';
      el('home-body').insertBefore(box, el('home-grp-exercises'));
      box.addEventListener('click', ev => {
        const b = ev.target.closest('[data-go]');
        if (!b) return;
        if (b.dataset.go === 'next') { const n = nextOf('tracks'); if (n) n.run(); }
        else location.hash = b.dataset.go;
      });
    }
    const last = store.get(LAST, null), d = describe(last), tr = cache.tracks, next = tr && tr.next;
    const cards = [];
    if (d) cards.push(`<div class="hc-card"><div class="hc-kind">Continue where you left off</div>
      <div class="hc-title">${esc(d.title)}</div><div class="hc-sub">${esc(d.kind)}${d.sub ? ' · ' + esc(d.sub) : ''} · ${STATUS_TXT[d.status] || ''}</div>
      <button class="hc-btn" type="button" data-go="${esc(last)}">Continue →</button></div>`);
    if (next && last !== `#/ex/${next.label.split(' ')[0]}`) cards.push(`<div class="hc-card"><div class="hc-kind">Next up in ${esc(tr.what)}</div>
      <div class="hc-title">${esc(next.label)}</div><div class="hc-sub">${tr.done}/${tr.total} done</div>
      <button class="hc-btn" type="button" data-go="next">Start →</button></div>`);
    box.innerHTML = cards.join('');
    box.classList.toggle('hidden', !cards.length);
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
    const body = el('home-body');
    body.addEventListener('scroll', syncBar, { passive: true });
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
  return { refresh: refreshSummaries, expandById, apply };
})();
