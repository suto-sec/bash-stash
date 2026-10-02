// The exam path (data: path-data.js): a fixed order of stages, each mixing warm-ups, exercises, scripts, quizzes and practice exams.
//   - ExamPath.render(box): the card on the home page (stages fold open, every item is a chip with its status)
//   - ExamPath.next(after): the next open item of the path, for "what next" and the Continue button
//   - the exercise sidebar can show only the path's exercises, in path order (state.track === 'path')
'use strict';
const ExamPath = (() => {
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const KINDS = [['warm', 'Warm-up'], ['ex', 'Exercises'], ['sc', 'Scripts'], ['quiz', 'Quizzes'], ['exam', 'Theory exams'], ['sx', 'Script exams']];
  const store = {
    get(k, d) { try { const v = JSON.parse(localStorage.getItem(k)); return v == null ? d : v; } catch { return d; } },
    set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch { /* private mode */ } },
  };
  const exSet = new Set(PATH_DATA.flatMap(s => [...(s.warm || []), ...(s.ex || [])]));
  const exOrder = PATH_DATA.flatMap(s => [...(s.warm || []), ...(s.ex || [])]);
  const hasEx = id => exSet.has(id);
  const ordered = () => exOrder.map(id => (state.flat || []).find(e => e.id === id)).filter(Boolean);

  // one uniform description of any item: { kind, id, label, short, status: 'pass' | 'part' | 'new', hash }
  function item(kind, id) {
    const exStatus = e => e.status === 'pass' ? 'pass' : e.status === 'new' ? 'new' : 'part';
    if (kind === 'warm' || kind === 'ex') {
      const e = (state.flat || []).find(x => x.id === id);
      return e ? { kind, id, label: `${id} · ${e.title}`, short: id, status: exStatus(e), ex: true, hash: `#/ex/${id}` } : null;
    }
    if (kind === 'sc') {
      const e = Scripts.entry(id);
      if (!e) return null;
      const step = (e.steps.find(s => !e.passed.includes(s.n)) || e.steps[e.steps.length - 1]).n;
      return { kind, id, label: `${id.slice(1)} · ${e.title}`, short: e.title, status: e.status === 'pass' ? 'pass' : e.passed.length ? 'part' : 'new', hash: `#/script/${id}/${step}` };
    }
    if (kind === 'quiz') {
      const c = Theory.collection(id);
      if (!c) return null;
      const qs = c.groups.flatMap(g => g.questions), p = qs.filter(q => q.status === 'pass').length;
      return { kind, id, label: c.title, short: c.title, status: p === qs.length && qs.length ? 'pass' : p ? 'part' : 'new', hash: `#/theory/${id}` };
    }
    if (kind === 'exam') {
      const e = Exams.entry(id);
      return e ? { kind, id, label: e.title, short: e.title, status: ({ pass: 'pass', attempted: 'part' })[Exams.statusOf(e)] || 'new', hash: `#/exam/${id}` } : null;
    }
    if (kind === 'sx') {
      const e = SExams.entry(id);
      return e ? { kind, id, label: `${e.title}`, short: e.title, status: ({ pass: 'pass', attempted: 'part' })[SExams.statusOf(e)] || 'new', hash: `#/sexam/${id}` } : null;
    }
    return null;
  }
  const stageItems = st => KINDS.flatMap(([k]) => (st[k] || []).map(id => item(k, id)).filter(Boolean));
  const allItems = () => PATH_DATA.flatMap(stageItems);
  const open = it => {
    if (!it) return;
    if (it.ex) { if (typeof selectTrack === 'function') selectTrack('path', it.id); else location.hash = it.hash; }
    else location.hash = it.hash;
  };
  // the next open item after `after` ({kind, id}), else the first open one
  function next(after) {
    const list = allItems(), i = after ? list.findIndex(x => x.kind === after.kind && x.id === after.id) : -1;
    return list.slice(i + 1).find(x => x.status !== 'pass') || list.find(x => x.status !== 'pass' && !(after && x.kind === after.kind && x.id === after.id)) || null;
  }
  const stats = st => { const it = stageItems(st); return { done: it.filter(x => x.status === 'pass').length, total: it.length, items: it }; };

  function render(box) {
    if (!box || !state.flat || !state.flat.length) return;
    const rows = PATH_DATA.map(st => ({ st, ...stats(st) }));
    const doneAll = rows.reduce((s, r) => s + r.done, 0), totalAll = rows.reduce((s, r) => s + r.total, 0);
    const cur = rows.findIndex(r => r.done < r.total);
    const open0 = store.get('pathOpen', null);
    const opened = new Set(open0 || (cur >= 0 ? [PATH_DATA[cur].id] : []));
    const nx = next(null);
    box.innerHTML = `<div class="ep-top"><div><div class="hr-title">Suggested path <span class="hint">— the exam material in order, nothing else</span></div>
        <div class="ep-sub">${doneAll}/${totalAll} done · ${PATH_DATA.length} stages · warm-ups, exercises, scripts, quizzes and practice exams in every stage</div></div>
        ${nx ? `<button type="button" class="hc-btn ep-go" data-ep-go="1">${doneAll ? 'Continue' : 'Start'}: ${esc(nx.label.length > 44 ? nx.label.slice(0, 43) + '…' : nx.label)} →</button>` : '<span class="ep-fin">Path complete ✔</span>'}</div>
      <div class="ep-bar"><i style="width:${totalAll ? 100 * doneAll / totalAll : 0}%"></i></div>
      <ol class="ep-stages">${rows.map((r, i) => {
        const done = r.total && r.done >= r.total, isCur = i === cur, isOpen = opened.has(r.st.id);
        const groups = KINDS.map(([k, name]) => {
          const its = r.items.filter(x => x.kind === k);
          if (!its.length) return '';
          const long = k !== 'warm' && k !== 'ex';
          return `<div class="ep-grp"><span class="ep-gname">${name} <span class="hint">${its.filter(x => x.status === 'pass').length}/${its.length}</span></span>
            <span class="ep-chips">${its.map(x => `<a href="${x.hash}" class="ep-chip st-${x.status}${long ? ' ep-long' : ''}" data-ep="${x.kind}:${esc(x.id)}" title="${esc(x.label)}">${esc(long ? x.short : x.short)}</a>`).join('')}</span></div>`;
        }).join('');
        return `<li class="ep-stage${done ? ' done' : ''}${isCur ? ' current' : ''}${isOpen ? ' open' : ''}" data-stage="${r.st.id}">
          <button type="button" class="ep-row" data-ep-toggle="${r.st.id}" aria-expanded="${isOpen}">
            <span class="ep-n">${done ? '✔' : i + 1}</span><span class="ep-name">${esc(r.st.title)}</span>
            <span class="ep-mini"><i style="width:${r.total ? 100 * r.done / r.total : 0}%"></i></span><span class="ep-count">${r.done}/${r.total}</span><span class="ep-chev">▸</span></button>
          <div class="ep-body"><p class="ep-why">${esc(r.st.why)}</p>${groups}</div></li>`;
      }).join('')}</ol>`;
  }
  document.addEventListener('click', ev => {
    const box = ev.target.closest('#home-roadmap');
    if (!box) return;
    const chip = ev.target.closest('[data-ep]');
    if (chip) { ev.preventDefault(); const [k, ...id] = chip.dataset.ep.split(':'); open(item(k, id.join(':'))); return; }
    if (ev.target.closest('[data-ep-go]')) { open(next(null)); return; }
    const tg = ev.target.closest('[data-ep-toggle]');
    if (tg) {
      const id = tg.dataset.epToggle, li = tg.closest('.ep-stage');
      li.classList.toggle('open');
      tg.setAttribute('aria-expanded', String(li.classList.contains('open')));
      store.set('pathOpen', [...box.querySelectorAll('.ep-stage.open')].map(x => x.dataset.stage));
    }
  });
  const total = () => { const r = PATH_DATA.map(stats); return { done: r.reduce((n, x) => n + x.done, 0), total: r.reduce((n, x) => n + x.total, 0) }; };
  return { render, next, open, item, hasEx, ordered, stats: total, data: PATH_DATA };
})();
