// The first minutes: less lost, less overwhelmed.
//   - the suggested path on the home page (path.js), always showing where you are
//   - (the "Start here" hero of the home page lives in home.js)
//   - a short tour of the exercise screen (offered once, replayable from Settings)
//   - after a Check: what to do next when it passed, and a nudge towards the available help when you are stuck
'use strict';
const NewUser = (() => {
  const $1 = id => document.getElementById(id);
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const store = {
    get(k, d) { try { const v = JSON.parse(localStorage.getItem(k)); return v == null ? d : v; } catch { return d; } },
    set(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch { /* private mode */ } },
  };

  // ---------------------------------------------------------------- the suggested path (path.js)
  const pass = e => e.status === 'pass';
  function renderRoadmap() {
    const home = $1('home-body');
    if (!home || !state.flat) return;
    let box = $1('home-roadmap');
    if (!box) {
      box = document.createElement('div');
      box.id = 'home-roadmap'; box.className = 'home-roadmap';
      home.insertBefore(box, $1('home-grp-exercises'));
    }
    ExamPath.render(box);
  }

  // ---------------------------------------------------------------- the tour
  const STEPS = [
    { sel: '#sidebar', text: 'Every exercise of the track is listed here. ✔ passed, ● started, ○ not started. The search box above filters by id, title or command.', side: 'right' },
    { sel: '#readme', text: 'The task. It says what to write and shows the expected output. Read it all, including the hints.', side: 'right' },
    { sel: '#ws-tabs', text: 'Your workspace: a real terminal or VS Code, whichever you prefer. Both edit the same answer file, so you can switch any time.', side: 'bottom' },
    { sel: '#check-btn', text: 'Check runs your answer against the reference on random files and tells you what differs. Shortcut: Ctrl+Enter.', side: 'bottom' },
    { sel: '#info-btn', text: 'Info explains the commands this exercise needs, with options and examples.', side: 'bottom' },
    { sel: '#solution-btn', text: 'Show solution is the last resort: the exercise is then marked "solution viewed" until you pass it.', side: 'bottom' },
    { sel: '#palette-btn', text: 'Ctrl+K searches every exercise, script and manual entry. The Reference next to it is the full manual of the course.', side: 'bottom' },
  ];
  let tour = null;
  const shown = el => !!el && el.offsetParent !== null;
  function tourEls() { return STEPS.map(s => ({ ...s, el: document.querySelector(s.sel) })).filter(s => shown(s.el)); }
  function drawTour() {
    const t = tour;
    if (!t) return;
    const s = t.steps[t.i], r = s.el.getBoundingClientRect(), pad = 5;
    Object.assign(t.ring.style, { left: r.left - pad + 'px', top: r.top - pad + 'px', width: r.width + 2 * pad + 'px', height: r.height + 2 * pad + 'px' });
    t.card.innerHTML = `<div class="tour-count">${t.i + 1} of ${t.steps.length}</div><p>${esc(s.text)}</p>
      <div class="tour-btns"><button type="button" data-t="skip" class="linklike">Skip tour</button><span class="spacer"></span>
      ${t.i ? '<button type="button" data-t="back">Back</button>' : ''}<button type="button" data-t="next" class="hc-btn">${t.i === t.steps.length - 1 ? 'Done' : 'Next'}</button></div>`;
    const cw = 320, ch = t.card.offsetHeight || 150, vw = innerWidth, vh = innerHeight;
    let x = s.side === 'right' ? r.right + 16 : r.left, y = s.side === 'right' ? r.top : r.bottom + 16;
    if (x + cw > vw - 12) x = Math.max(12, vw - cw - 12);
    if (y + ch > vh - 12) y = Math.max(12, vh - ch - 12);
    Object.assign(t.card.style, { left: x + 'px', top: y + 'px', width: cw + 'px' });
  }
  function endTour(done) {
    if (!tour) return;
    tour.ring.remove(); tour.card.remove(); tour = null;
    document.removeEventListener('keydown', tourKey, true);
    removeEventListener('resize', drawTour);
    if (done) store.set('tourDone', true);
  }
  function stepTour(d) {
    if (!tour) return;
    const i = tour.i + d;
    if (i < 0) return;
    if (i >= tour.steps.length) { endTour(true); return; }
    tour.i = i; drawTour();
  }
  function tourKey(ev) {
    if (!tour) return;
    if (ev.key === 'Escape') { ev.preventDefault(); ev.stopPropagation(); endTour(true); }
    else if (ev.key === 'ArrowRight' || ev.key === 'Enter') { ev.preventDefault(); ev.stopPropagation(); stepTour(1); }
    else if (ev.key === 'ArrowLeft') { ev.preventDefault(); ev.stopPropagation(); stepTour(-1); }
  }
  function runTour() {
    const steps = tourEls();
    if (!steps.length) return;
    endTour(false);
    const ring = document.createElement('div'), card = document.createElement('div');
    ring.className = 'tour-ring'; card.className = 'tour-card'; card.setAttribute('role', 'dialog');
    document.body.append(ring, card);
    tour = { steps, i: 0, ring, card };
    card.addEventListener('click', ev => {
      const b = ev.target.closest('[data-t]');
      if (!b) return;
      if (b.dataset.t === 'next') stepTour(1); else if (b.dataset.t === 'back') stepTour(-1); else endTour(true);
    });
    document.addEventListener('keydown', tourKey, true);
    addEventListener('resize', drawTour);
    drawTour(); drawTour();
  }
  // from anywhere: go to an exercise first if the exercise screen is not up
  function startTour() {
    if (shown($1('check-btn')) && /^#\/ex\//.test(location.hash)) { runTour(); return; }
    const intro = (state.flat || []).filter(e => e.tier === 0);
    const first = intro.find(e => !pass(e)) || intro[0] || (state.flat || [])[0];
    if (first) { if (typeof selectIntroCategory === 'function' && first.tier === 0) selectIntroCategory('all', first.id); else location.hash = `#/ex/${first.id}`; }
    let n = 0;
    const t = setInterval(() => { if (/^#\/ex\//.test(location.hash) && shown($1('check-btn')) && $1('readme').textContent.length > 5) { clearInterval(t); setTimeout(runTour, 400); } else if (++n > 60) clearInterval(t); }, 150);
  }
  // offered once, the first time an exercise is opened
  function offerTour() {
    if (store.get('tourDone', false) || store.get('tourOffered', false)) return;
    if (!/^#\/ex\//.test(location.hash)) return;
    store.set('tourOffered', true);
    setTimeout(() => {
      if (document.getElementById('tour-offer') || tour) return;
      const o = document.createElement('div');
      o.id = 'tour-offer'; o.className = 'tour-offer';
      o.innerHTML = `<span>First time here? A 1-minute tour shows where everything is.</span><button type="button" data-o="go" class="hc-btn">Take the tour</button><button type="button" data-o="no" class="linklike">Not now</button>`;
      document.body.appendChild(o);
      o.addEventListener('click', ev => { const b = ev.target.closest('[data-o]'); if (!b) return; o.remove(); if (b.dataset.o === 'go') runTour(); else store.set('tourDone', true); });
      setTimeout(() => o.remove(), 20000);
    }, 1500);
  }

  // ---------------------------------------------------------------- after a Check
  const fails = () => { try { return JSON.parse(sessionStorage.getItem('nuFails')) || {}; } catch { return {}; } };
  const setFails = f => { try { sessionStorage.setItem('nuFails', JSON.stringify(f)); } catch { /* private mode */ } };
  function nextExercise(id) {
    const pool = visibleFlat(), i = pool.findIndex(e => e.id === id);
    return pool.slice(i + 1).find(e => !pass(e)) || pool.find(e => e.id !== id && !pass(e)) || null;
  }
  // finishing something that is on the suggested path: the next open item of the path (null = all done, undefined = not on the path)
  const KIND_NAME = { warm: 'warm-up', ex: 'exercise', sc: 'script', quiz: 'quiz', exam: 'theory exam', sx: 'script exam' };
  function onPath(ctx) {
    if (ctx.kind === 'ex') {
      if (state.track !== 'path' || state.introCategory) return undefined;
      const e = state.flat.find(x => x.id === ctx.id);
      return e && ExamPath.hasEx(e.id) ? ExamPath.next({ kind: e.tier === 0 ? 'warm' : 'ex', id: e.id }) : undefined;
    }
    if (ctx.kind === 'script') {
      const e = Scripts.entry(ctx.id);
      if (!e || ctx.step < e.steps.length || !ExamPath.data.some(st => (st.sc || []).includes(ctx.id))) return undefined;   // only when the whole script is done
      return ExamPath.next({ kind: 'sc', id: ctx.id });
    }
    return undefined;
  }
  // `ctx`: { ok, kind: 'ex' | 'script', id, step } — appends to the result box
  const slot = () => $1('nu-slot');
  function clear() { if (slot()) slot().innerHTML = ''; }
  function afterCheck(ctx) {
    const body = slot();
    if (!body || !ctx) return;
    body.innerHTML = '';
    const key = `${ctx.kind}:${ctx.id}:${ctx.step || ''}`, f = fails();
    let html = '';
    if (ctx.ok) {
      delete f[key]; setFails(f);
      const pn = onPath(ctx);
      if (pn !== undefined) {
        html = pn ? `<div class="nu-box"><span>Next on your path: <b>${esc(pn.label)}</b> <span class="hint">(${KIND_NAME[pn.kind]})</span></span><button type="button" class="hc-btn" data-nu="path:${esc(pn.kind)}:${esc(pn.id)}">Continue the path →</button></div>`
          : `<div class="nu-box"><span>You finished the whole suggested path. Nice work!</span><button type="button" class="hc-btn" data-nu="home">Back to home →</button></div>`;
      } else if (ctx.kind === 'ex') {
        const nx = nextExercise(ctx.id), pool = visibleFlat(), left = pool.filter(e => e.id !== ctx.id && !pass(e)).length;
        html = nx ? `<div class="nu-box"><span>Next: <b>${esc(nx.id)} · ${esc(nx.title)}</b> <span class="hint">(${left} left in this list)</span></span><button type="button" class="hc-btn" data-nu="ex:${esc(nx.id)}">Next exercise →</button></div>`
          : `<div class="nu-box"><span>That was the last open exercise of this list. Nice work!</span><button type="button" class="hc-btn" data-nu="home">Choose what is next →</button></div>`;
      } else if (ctx.kind === 'script') {
        const e = Scripts.entry(ctx.id);
        if (e && ctx.step < e.steps.length) html = `<div class="nu-box"><span>Next: <b>step ${ctx.step + 1} · ${esc(e.steps[ctx.step].title)}</b></span><button type="button" class="hc-btn" data-nu="script:${esc(ctx.id)}:${ctx.step + 1}">Next step →</button></div>`;
        else {
          const nx = e && e.imp ? null : Scripts.list().find(x => x.id !== ctx.id && x.status !== 'pass');
          html = `<div class="nu-box"><span>Script complete!${nx ? ` Next script: <b>${esc(nx.id.slice(1))} · ${esc(nx.title)}</b>` : ''}</span><button type="button" class="hc-btn" data-nu="${nx ? 'script:' + esc(nx.id) + ':1' : 'home'}">${nx ? 'Next script →' : 'Back to home →'}</button></div>`;
        }
      }
    } else if (ctx.code !== '3') {
      f[key] = (f[key] || 0) + 1; setFails(f);
      if (f[key] >= 2) html = `<div class="nu-box nu-help"><span><b>Stuck?</b> Compare your output with the expected one above, run your script on the same files with <i>Try with these test files</i>,
        and open <b>Info</b> for the commands this exercise uses. <i>Show solution</i> is always there as the last step.</span><button type="button" data-nu="info">Open Info</button></div>`;
    }
    if (html) body.innerHTML = html;
  }
  document.addEventListener('click', ev => {
    const b = ev.target.closest('[data-nu]');
    if (!b) return;
    const [kind, id, step] = b.dataset.nu.split(':');
    if (kind === 'path') ExamPath.open(ExamPath.item(id, step));
    else if (kind === 'ex') { location.hash = `#/ex/${id}`; }
    else if (kind === 'script') Scripts.go(id, Number(step));
    else if (kind === 'info') $1('info-btn').click();
    else if (kind === 'home') location.hash = '#/home';
  });

  // ---------------------------------------------------------------- start
  function refresh() {
    renderRoadmap();   // the order of the boxes on the home page is decided by home.js
  }
  if (typeof Home !== 'undefined' && Home.onRefresh) Home.onRefresh(refresh);
  window.addEventListener('hashchange', offerTour);
  offerTour();
  const tb = $1('tour-row');
  if (tb) tb.onclick = () => { $1('settings-menu').classList.add('hidden'); $1('settings-btn').setAttribute('aria-expanded', 'false'); store.set('startHidden', false); startTour(); };
  return { refresh, startTour, afterCheck, clear };
})();
