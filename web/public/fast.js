// The fast track: a short ordered plan for the final stretch (data: fast-data.js).
// Unlike the suggested path (path.js) it is a short ordered to-do list, and it never
// touches the readiness view (that keeps weighing the whole suggested path, ExamPath.data).
//   - FastTrack.render(box): the card on the home page (blocks fold open, every item is a numbered chip with its status)
//   - FastTrack.next(after) / open(item): same contract as ExamPath, so "Continue" and the hero work with either
//   - state.track === 'fast': the exercise sidebar shows only the fast track's exercises, in plan order
// Items marked 'x' are extras (added for the plan) and 'o' optional ones (only if ahead); neither counts in the time estimate. Items of kind 'note' are plain text tips shown above the chips (not items: no status, not counted).
'use strict';
const FastTrack = (() => {
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const store = {
    get(k, d) { try { const v = JSON.parse(localStorage.getItem(k)); return v == null ? d : v; } catch { return d; } },
    set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch { /* private mode */ } },
  };
  const KIND_NAME = { ex: 'exercise', sc: 'script', quiz: 'quiz', exam: 'theory exam', sx: 'script exam' };
  const mode = () => store.get('pathMode', 'path');
  const active = () => mode() === 'fast' && typeof FAST_DATA !== 'undefined';
  const exIds = () => FAST_DATA.flatMap(b => b.items.filter(i => i[0] === 'ex').map(i => i[1]));
  const exSet = () => new Set(exIds());
  const hasEx = id => typeof FAST_DATA !== 'undefined' && exSet().has(id);
  const ordered = () => exIds().map(id => (state.flat || []).find(e => e.id === id)).filter(Boolean);

  // one uniform description of an item: { kind, id, label, short, status: 'pass' | 'part' | 'new', hash, extra }
  function item([kind, id, extra]) {
    const x = extra === 'x' || extra === 'o';   // x = extra added to the plan, o = optional: neither is in the time estimate
    const it = ExamPath.item(kind, id);
    return it && { ...it, kind, extra: x, ex: kind === 'ex' };
  }
  const blockItems = b => b.items.filter(i => i[0] !== 'note').map(item).filter(Boolean);
  const blockNotes = b => b.items.filter(i => i[0] === 'note').map(i => i[2]);
  const allItems = () => FAST_DATA.flatMap(blockItems);
  function open(it) {
    if (!it) return;
    if (it.ex) { if (typeof selectTrack === 'function') selectTrack('fast', it.id); else location.hash = it.hash; }
    else location.hash = it.hash;
  }
  function next(after) {
    const list = allItems().filter(x => !x.extra), i = after ? list.findIndex(x => x.kind === after.kind && x.id === after.id) : -1;
    return list.slice(i + 1).find(x => x.status !== 'pass') || list.find(x => x.status !== 'pass' && !(after && x.kind === after.kind && x.id === after.id)) || null;
  }
  const hrs = m => m >= 60 ? `${Math.round(m / 6) / 10}h`.replace('.0h', 'h') : `${m} min`;
  function stats(b) {
    const its = blockItems(b), core = its.filter(x => !x.extra);   // extras and optional items are shown but not counted
    const done = core.filter(x => x.status === 'pass').length;
    const left = core.length ? Math.round(b.mins * (core.length - done) / core.length) : 0;
    return { its, done, total: core.length, left };
  }
  function switchHtml() {
    const m = mode();
    return `<div class="ep-switch" role="radiogroup" aria-label="Which plan"><button type="button" role="radio" aria-checked="${m !== 'fast'}" class="${m !== 'fast' ? 'on' : ''}" data-pmode="path">Suggested path</button><button type="button" role="radio" aria-checked="${m === 'fast'}" class="${m === 'fast' ? 'on' : ''}" data-pmode="fast">Fast track</button></div>`;
  }

  function render(box) {
    if (!box || !state.flat || !state.flat.length) return;
    const rows = FAST_DATA.map(b => ({ b, ...stats(b) }));
    const doneAll = rows.reduce((s, r) => s + r.done, 0), totalAll = rows.reduce((s, r) => s + r.total, 0);
    const leftMin = rows.reduce((s, r) => s + r.left, 0), cur = rows.findIndex(r => r.done < r.total);
    const opened = new Set(store.get('fastOpen', null) || (cur >= 0 ? [FAST_DATA[cur].id] : []));
    const nx = next(null);
    box.classList.remove('folded');
    box.innerHTML = `<div class="ep-top"><div><div class="hr-title">Fast track</div>
        <div class="ep-sub">${doneAll}/${totalAll} done${leftMin ? ` · about ${hrs(leftMin)} of planned work left` : ''}</div></div>
        ${switchHtml()}</div>
      <div class="ep-bar"><i style="width:${totalAll ? 100 * doneAll / totalAll : 0}%"></i></div>
      ${nx ? `<div class="ep-nextline">Next: <a href="${esc(nx.hash)}" data-fast="${nx.kind}:${esc(nx.id)}"><b>${esc(nx.label)}</b></a> <span class="hint">(${KIND_NAME[nx.kind]})</span></div>` : '<div class="ep-nextline"><span class="ep-fin">Fast track complete ✔</span></div>'}
      <ol class="ep-stages">${rows.map((r, i) => {
        const done = r.total && r.done >= r.total, isCur = i === cur, isOpen = opened.has(r.b.id);
        const chips = r.its.map(x => `<a href="${x.hash}" class="ep-chip st-${x.status}${x.kind === 'ex' || x.kind === 'sc' ? '' : ' ep-long'}${x.extra ? ' ep-extra' : ''}" data-fast="${x.kind}:${esc(x.id)}" title="${esc(x.label)}${x.extra ? ' (not in the time estimate)' : ''}">${esc(x.short)}</a>`).join('');
        const tips = blockNotes(r.b).map(t => `<li>${esc(t)}</li>`).join('');
        return `<li class="ep-stage${done ? ' done' : ''}${isCur ? ' current' : ''}${isOpen ? ' open' : ''}" data-stage="${r.b.id}">
          <button type="button" class="ep-row" data-fast-toggle="${r.b.id}" aria-expanded="${isOpen}">
            <span class="ep-n">${done ? '✔' : i + 1}</span><span class="ep-name">${esc(r.b.title)}</span>
            <span class="ep-mini"><i style="width:${r.total ? 100 * r.done / r.total : 0}%"></i></span><span class="ep-count">${r.total ? `${r.done}/${r.total} · ` : ''}${r.b.mins ? hrs(r.b.mins) : 'extra'}</span><span class="ep-chev">▸</span></button>
          <div class="ep-body"><p class="ep-why">${esc(r.b.why)}</p>${tips ? `<ul class="ep-tips">${tips}</ul>` : ''}<div class="ep-chips ep-fastchips">${chips}</div></div></li>`;
      }).join('')}</ol>
      <p class="ep-foot hint">Dashed chips are extras or optional and are not in the time plan.</p>`;
  }

  document.addEventListener('click', ev => {
    const box = ev.target.closest('#home-roadmap');
    if (!box) return;
    const pm = ev.target.closest('[data-pmode]');
    if (pm) { store.set('pathMode', pm.dataset.pmode); if (typeof NewUser !== 'undefined') NewUser.refresh(); return; }
    const chip = ev.target.closest('[data-fast]');
    if (chip) { ev.preventDefault(); const [k, ...id] = chip.dataset.fast.split(':'); open(allItems().find(x => x.kind === k && x.id === id.join(':'))); return; }
    const tg = ev.target.closest('[data-fast-toggle]');
    if (tg) {
      const li = tg.closest('.ep-stage');
      li.classList.toggle('open');
      tg.setAttribute('aria-expanded', String(li.classList.contains('open')));
      store.set('fastOpen', [...box.querySelectorAll('.ep-stage.open')].map(x => x.dataset.stage));
    }
  });
  return { render, next, open, item, hasEx, ordered, active, mode, switchHtml };
})();
