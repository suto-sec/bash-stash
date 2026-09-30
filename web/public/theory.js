// bash stash — Theory quizzes (interactive, graded in the browser, progress stored by the server).
// Collections live in theory/<id>.json (compiled from tools/theory/*.txt by tools/build_theory.js).
// Question types: single, multi, fill, order, match, sort. Every answer is explained after checking,
// option by option (why each right one is right AND why each wrong one is wrong).
'use strict';
const Theory = (() => {
  const TYPE_LABEL = {
    single: 'Single choice', multi: 'Multiple choice · select all that apply', fill: 'Fill in the blank',
    order: 'Put in order · drag or use the arrows', match: 'Match the pairs · drag, or click a chip then a slot',
    sort: 'Sort into categories · drag, or click a chip then a category',
  };
  const VERDICT_STATUS = { pass: 'passed', attempted: 'tried', new: 'not started' };
  let index = [];          // light index with per-question status (from /api/theory)
  const cache = {};        // collection id -> full collection (questions, answers, explanations)
  let view = null;         // the question currently shown: { cid, item, handle, checked }

  const md = s => marked.parse(s || '');
  const mdi = s => marked.parseInline(s || '');
  const norm = s => String(s).trim().replace(/\s+/g, ' ');
  function shuffle(a) {
    const r = a.slice();
    for (let i = r.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [r[i], r[j]] = [r[j], r[i]]; }
    return r;
  }
  const sameOrder = (a, b) => a.length === b.length && a.every((x, i) => x === b[i]);

  // ---------------------------------------------------------------- data
  async function load() {
    try { index = await (await fetch('/api/theory')).json(); } catch { index = []; }
    if (!Array.isArray(index)) index = [];
  }
  const collection = id => index.find(c => c.id === id);
  const total = c => c.groups.reduce((s, g) => s + g.questions.length, 0);
  const passed = c => c.groups.reduce((s, g) => s + g.questions.filter(q => q.status === 'pass').length, 0);
  // flat list of {q, group, n} (n = 1-based number in the collection) from the light index
  function flat(cid) {
    const out = [];
    const c = collection(cid);
    if (c) for (const g of c.groups) for (const q of g.questions) out.push({ q, group: g, n: out.length + 1 });
    return out;
  }
  function setStatus(cid, qid, status) {
    const it = flat(cid).find(x => x.q.id === qid);
    if (it) it.q.status = status;
  }

  // ---------------------------------------------------------------- home page cards
  function renderHomeGrid() {
    const grid = $('#theory-grid');
    if (!index.length) { grid.innerHTML = '<p class="home-intro">No theory collections built yet (run <code>node tools/build_theory.js</code>).</p>'; return; }
    grid.innerHTML = index.map(c => {
      const t = total(c), p = passed(c);
      return `<button class="track-card${state.theory === c.id ? ' current' : ''}" data-theory="${esc(c.id)}">
        <div class="track-card-title">${esc(c.title)}</div>
        <div class="track-card-desc">${esc(c.about || '')}</div>
        <div class="track-card-count">${p}/${t} questions</div>
      </button>`;
    }).join('');
  }
  $('#theory-grid').addEventListener('click', ev => {
    const card = ev.target.closest('[data-theory]');
    if (!card) return;
    const cid = card.dataset.theory;
    state.introCategory = null;
    try { localStorage.removeItem('introCategory'); } catch { /* private mode */ }
    const next = flat(cid).find(x => x.q.status !== 'pass') || flat(cid)[0];
    location.hash = next ? `#/theory/${cid}/${next.q.id}` : '#/home';
  });

  // ---------------------------------------------------------------- show / hide the quiz panel
  function showMain() {
    $('#main').classList.add('hidden');
    $('#theory-main').classList.remove('hidden');
  }
  function hide() {
    $('#theory-main').classList.add('hidden');
    $('#main').classList.remove('hidden');
    const r = $('#th-reset'); if (r) r.classList.add('hidden');
    document.querySelector('.overall').title = 'exercises passed';
    $('#search').placeholder = 'Search id, title or command…';
    // the terminal was hidden while the quiz was up: let it re-measure itself
    requestAnimationFrame(() => { if (typeof fit !== 'undefined' && fit) try { fit.fit(); } catch { /* hidden */ } });
  }

  async function open(cid, qid) {
    const c = collection(cid);
    if (!c) { location.replace('#/home'); return; }
    state.theory = cid;
    const list = flat(cid);
    const item = list.find(x => x.q.id === qid);
    if (!item) {
      const pick = list.find(x => x.q.status !== 'pass') || list[0];
      if (pick) location.replace(`#/theory/${cid}/${pick.q.id}`); else location.replace('#/home');
      return;
    }
    if (!cache[cid]) {
      try { cache[cid] = await (await fetch(`/api/theory/${cid}`)).json(); }
      catch { return; }
    }
    if (state.theory !== cid) return; // navigated away while loading
    showMain();
    updateTrackBadge();
    renderSidebar();
    renderQuestion(cid, item);
  }

  // ---------------------------------------------------------------- sidebar
  function ensureResetButton() {
    let b = $('#th-reset');
    if (!b) {
      b = document.createElement('button');
      b.id = 'th-reset'; b.className = 'small'; b.textContent = 'Reset progress';
      b.title = 'Forget your results for this collection';
      b.onclick = async () => {
        const c = collection(state.theory);
        if (!c || !confirm(`Forget all your results in "${c.title}"?`)) return;
        await fetch(`/api/theory/${c.id}/reset`, { method: 'POST' });
        await load();
        const first = flat(c.id)[0];
        if (first) location.hash = `#/theory/${c.id}/${first.q.id}`;
        renderSidebar();
      };
      $('.sidebar-tools').appendChild(b);
    }
    b.classList.remove('hidden');
  }

  function renderSidebar() {
    const c = collection(state.theory);
    if (!c) return;
    ensureResetButton();
    $('#search').placeholder = 'Search questions…';
    document.querySelector('.overall').title = 'theory questions passed';
    const q = $('#search').value.trim().toLowerCase();
    const hidePassed = $('#hide-passed').checked;
    const nav = $('#topics');
    const sameCol = nav.dataset.theoryFor === c.id;
    const openGroups = new Set([...nav.querySelectorAll('.topic[open]')].map(d => d.dataset.topic));
    const curId = view && view.cid === c.id ? view.item.q.id : null;
    const nums = new Map(flat(c.id).map(x => [x.q.id, x.n]));
    nav.innerHTML = '';
    nav.dataset.theoryFor = c.id;
    for (const g of c.groups) {
      const p = g.questions.filter(x => x.status === 'pass').length;
      const qs = g.questions.filter(x =>
        (!q || `${x.title} ${g.title} ${x.type}`.toLowerCase().includes(q)) && !(hidePassed && x.status === 'pass'));
      if (!qs.length) continue;
      const d = document.createElement('details');
      d.className = 'topic';
      d.dataset.topic = g.id;
      d.open = !!q || (sameCol ? openGroups.has(g.id) : false) || g.questions.some(x => x.id === curId);
      d.innerHTML = `<summary><span class="t-name">${esc(g.title)}</span><span class="t-count">${p}/${g.questions.length}</span></summary>
        <div class="t-bar"><div style="width:${100 * p / g.questions.length}%"></div></div>`;
      for (const x of qs) {
        const a = document.createElement('a');
        a.className = 'ex-item' + (x.id === curId ? ' current' : '');
        a.href = `#/theory/${c.id}/${x.id}`;
        a.title = `${x.title} — ${VERDICT_STATUS[x.status] || x.status}`;
        a.innerHTML = `<span class="dot ${x.status}">${STATUS[x.status].dot}</span><span class="ex-id">${nums.get(x.id)}</span>
          <span class="ex-name">${esc(x.title)}</span>`;
        d.appendChild(a);
      }
      nav.appendChild(d);
    }
    const t = total(c), p = passed(c);
    $('#overall-fill').style.width = `${t ? 100 * p / t : 0}%`;
    $('#overall-text').textContent = `${p}/${t}`;
    const curEl = nav.querySelector('.ex-item.current');
    if (curEl) curEl.scrollIntoView({ block: 'nearest' });
  }

  // ---------------------------------------------------------------- question view
  const STATUS_CLASS = { pass: 'pass', attempted: 'attempted', new: '' };
  function setBadge(status) {
    const b = $('#th-status');
    b.className = 'badge ' + (STATUS_CLASS[status] || '');
    b.textContent = VERDICT_STATUS[status] || status;
  }

  function renderQuestion(cid, item) {
    const full = cache[cid];
    const group = full.groups.find(g => g.id === item.group.id);
    const q = group.questions.find(x => x.id === item.q.id);
    view = { cid, item, q, checked: false, handle: null };
    const list = flat(cid);
    $('#th-crumb').textContent = `Theory · ${full.title} · ${group.title}`;
    $('#th-title').textContent = q.title;
    $('#th-type').textContent = TYPE_LABEL[q.type];
    $('#th-counter').textContent = `Question ${item.n} of ${list.length}`;
    setBadge(item.q.status);
    document.title = `${q.title} — Theory — bash stash`;
    $('#th-feedback').classList.add('hidden');
    $('#th-feedback').innerHTML = '';
    $('#th-retry').classList.add('hidden');
    $('#th-prev').disabled = item.n <= 1;
    $('#th-next').disabled = item.n >= list.length;
    $('#theory-scroll').scrollTop = 0;
    paintQuestion();
  }

  // (re)builds the interactive part; also used by "Try again" (fresh shuffle)
  function paintQuestion() {
    const { q } = view;
    view.checked = false;
    const qEl = $('#th-question');
    let html = md(q.text);
    if (q.type === 'fill') {
      html = html.replace(/\{\{(\d+)\}\}/g, (_, i) => {
        const w = Math.max(4, ...q.blanks[i].answers.map(a => a.length)) + 2;
        return `<input class="th-blank" data-i="${i}" size="${Math.min(w, 40)}" spellcheck="false" autocomplete="off" autocapitalize="off" aria-label="blank ${Number(i) + 1}">`;
      });
    }
    qEl.innerHTML = html;
    const body = document.createElement('div');
    body.className = 'th-body';
    $('#th-body').replaceWith(body);
    body.id = 'th-body';
    // builders may call this while still being constructed (before view.handle exists)
    const onChange = () => { $('#th-check').disabled = view.checked || !view.handle || !view.handle.ready(); };
    view.handle = BUILDERS[q.type](q, body, qEl, onChange);
    $('#th-check').classList.remove('hidden');
    $('#th-check').disabled = true;
    $('#th-retry').classList.add('hidden');
    $('#th-feedback').classList.add('hidden');
    $('#th-hint').textContent = q.type === 'single' || q.type === 'multi' ? 'Press 1–9 to pick, Enter to check' : '';
    onChange();
    const first = body.querySelector('input,button') || qEl.querySelector('input');
    if (first && (q.type === 'fill')) first.focus();
  }

  async function check() {
    if (!view || view.checked || !view.handle.ready()) return;
    view.checked = true;
    const res = view.handle.grade();
    view.handle.reveal(res);
    $('#th-check').classList.add('hidden');
    $('#th-hint').textContent = '';
    $('#th-retry').textContent = res.ok ? 'Practice again' : 'Try again';
    $('#th-retry').classList.remove('hidden');
    const fb = $('#th-feedback');
    const c = collection(view.cid), last = flat(view.cid).length === view.item.n;
    fb.className = 'th-feedback ' + (res.ok ? 'good' : 'bad');
    fb.innerHTML = `<div class="th-verdict">${res.ok ? '✔ Correct' : '✘ Not quite'}${res.detail ? ` <span>${res.detail}</span>` : ''}</div>` +
      (view.q.note ? `<div class="th-note">${md(view.q.note)}</div>` : '') +
      (!res.ok ? '<div class="th-note hint">Read the explanations above, then press “Try again” for a fresh attempt — the ✔ in the sidebar comes from answering it right.</div>' : '');
    try {
      const r = await (await fetch(`/api/theory/${view.cid}/${view.q.id}`, {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ ok: res.ok }) })).json();
      if (r.status) { setStatus(view.cid, view.q.id, r.status); setBadge(r.status); }
    } catch { /* offline: the answer still counts on screen */ }
    if (c && passed(c) === total(c)) fb.innerHTML += '<div class="th-note th-done">🎉 Collection complete — every question answered correctly.</div>';
    fb.classList.remove('hidden');
    renderSidebar();
    fb.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    $('#th-next').focus({ preventScroll: true });
    if (last) $('#th-next').disabled = true;
  }

  function go(delta) {
    if (!view) return;
    const list = flat(view.cid);
    const n = list.find(x => x.n === view.item.n + delta);
    if (n) location.hash = `#/theory/${view.cid}/${n.q.id}`;
  }
  $('#th-check').onclick = check;
  $('#th-retry').onclick = () => { $('#th-feedback').classList.add('hidden'); paintQuestion(); };
  $('#th-prev').onclick = () => go(-1);
  $('#th-next').onclick = () => go(1);

  document.addEventListener('keydown', ev => {
    if (!state.theory || !view || ev.ctrlKey || ev.metaKey || ev.altKey) return;
    if ($('#theory-main').classList.contains('hidden')) return;
    const typing = ev.target.matches && ev.target.matches('input[type=text], input:not([type]), input.th-blank, textarea');
    if (ev.key === 'Enter') {
      if (ev.target.matches && ev.target.matches('button') && ev.target.id !== 'th-check') return; // let buttons act
      ev.preventDefault();
      if (!view.checked) check(); else go(1);
      return;
    }
    if (typing) return;
    if (ev.key === 'ArrowRight') go(1);
    else if (ev.key === 'ArrowLeft') go(-1);
    else if (/^[1-9]$/.test(ev.key) && !view.checked && view.handle.pick) view.handle.pick(Number(ev.key) - 1);
  });

  // ---------------------------------------------------------------- builders
  // Each builder renders its widget into `body` and returns
  //   { ready(): bool, grade(): {ok, detail?}, reveal(res), pick?(k) }
  const tag = (cls, text) => `<span class="th-tag ${cls}">${text}</span>`;

  function buildChoice(q, body, qEl, onChange) {
    const multi = q.type === 'multi';
    const opts = shuffle(q.options.map((o, i) => ({ ...o, i })));
    body.innerHTML = opts.map((o, k) => `
      <label class="th-opt" data-i="${o.i}">
        <input type="${multi ? 'checkbox' : 'radio'}" name="th-opt">
        <span class="th-mark"></span>
        <span class="th-opt-main"><span class="th-opt-text">${mdi(o.t)}</span><span class="th-why hidden"></span></span>
        <kbd>${k + 1}</kbd>
      </label>`).join('');
    const labels = [...body.querySelectorAll('.th-opt')];
    body.addEventListener('change', onChange);
    const picked = () => labels.filter(l => l.querySelector('input').checked).map(l => Number(l.dataset.i));
    return {
      ready: () => picked().length > 0,
      pick(k) { const inp = labels[k] && labels[k].querySelector('input'); if (inp) { inp.click(); inp.focus(); } },
      grade() {
        const sel = new Set(picked());
        const right = q.options.map((o, i) => o.ok ? i : -1).filter(i => i >= 0);
        const hit = right.filter(i => sel.has(i)).length, extra = [...sel].filter(i => !q.options[i].ok).length;
        const ok = hit === right.length && extra === 0;
        return { ok, detail: multi && !ok ? `${hit} of ${right.length} right answers found${extra ? `, ${extra} wrong pick${extra > 1 ? 's' : ''}` : ''}` : '' };
      },
      reveal() {
        const sel = new Set(picked());
        for (const l of labels) {
          const i = Number(l.dataset.i), o = q.options[i], p = sel.has(i);
          const cls = o.ok ? (p ? 'right' : 'missed') : (p ? 'wrong' : 'rejected');
          const label = o.ok ? (p ? (multi ? '✔ Correct — you picked it' : '✔ Correct answer — your pick')
                                  : (multi ? '✔ Also correct — you missed it' : '✔ This was the correct answer'))
                             : (p ? '✘ Wrong — your pick' : '✘ Not correct');
          l.classList.add(cls);
          l.querySelector('input').disabled = true;
          const w = l.querySelector('.th-why');
          w.innerHTML = tag(cls, label) + ' ' + mdi(o.why);
          w.classList.remove('hidden');
        }
      },
    };
  }

  function buildFill(q, body, qEl, onChange) {
    const inputs = [...qEl.querySelectorAll('.th-blank')];
    inputs.forEach(inp => inp.addEventListener('input', onChange));
    const okFor = (i, v) => q.blanks[i].answers.some(a => norm(a) === norm(v));
    return {
      ready: () => inputs.every(inp => norm(inp.value) !== ''),
      grade() {
        const bad = inputs.filter(inp => !okFor(Number(inp.dataset.i), inp.value)).length;
        return { ok: bad === 0, detail: bad ? `${inputs.length - bad} of ${inputs.length} blanks right` : '' };
      },
      reveal() {
        const rows = [];
        inputs.forEach(inp => {
          const i = Number(inp.dataset.i), v = norm(inp.value), ok = okFor(i, v);
          inp.disabled = true;
          inp.classList.add(ok ? 'right' : 'wrong');
          const accepted = q.blanks[i].answers.map(a => `<code>${esc(a)}</code>`).join(' or ');
          let line = `<div class="th-blank-row ${ok ? 'right' : 'wrong'}">${tag(ok ? 'right' : 'wrong', ok ? '✔ Correct' : '✘ Wrong')}
            ${inputs.length > 1 ? `Blank ${i + 1}: ` : ''}you wrote <code>${esc(v)}</code>${ok ? '' : ` · accepted: ${accepted}`}`;
          const hit = q.wrong && q.wrong.find(w => norm(w.a) === v);
          if (hit && !ok) line += `<div class="th-why">${mdi(hit.why)}</div>`;
          rows.push(line + '</div>');
        });
        let html = rows.join('');
        const others = (q.wrong || []).filter(w => !inputs.some(inp => norm(inp.value) === norm(w.a)));
        if (others.length) {
          html += `<div class="th-wrong-list"><div class="th-sub">Other tempting answers that don’t work</div>` +
            others.map(w => `<div class="th-blank-row"><code>${esc(w.a)}</code><div class="th-why">${mdi(w.why)}</div></div>`).join('') + '</div>';
        }
        body.innerHTML = html;
      },
    };
  }

  function buildOrder(q, body, qEl, onChange) {
    const n = q.items.length;
    let order = shuffle([...Array(n).keys()]);
    for (let t = 0; sameOrder(order, [...Array(n).keys()]) && t < 10; t++) order = shuffle(order);
    body.innerHTML = `<ol class="th-order">${order.map(i => `
      <li class="th-step" draggable="true" data-i="${i}">
        <span class="th-grip" aria-hidden="true">⠿</span>
        <span class="th-step-main"><span class="th-step-text">${mdi(q.items[i].t)}</span><span class="th-why hidden"></span></span>
        <span class="th-move"><button type="button" data-mv="-1" aria-label="move up">▲</button><button type="button" data-mv="1" aria-label="move down">▼</button></span>
      </li>`).join('')}</ol>`;
    const ol = body.querySelector('ol');
    let drag = null, locked = false;
    const cur = () => [...ol.children].map(li => Number(li.dataset.i));
    ol.addEventListener('dragstart', ev => {
      if (locked) return ev.preventDefault();
      drag = ev.target.closest('.th-step'); if (!drag) return;
      ev.dataTransfer.effectAllowed = 'move'; ev.dataTransfer.setData('text/plain', drag.dataset.i);
      drag.classList.add('dragging');
    });
    ol.addEventListener('dragend', () => { if (drag) drag.classList.remove('dragging'); drag = null; });
    ol.addEventListener('dragover', ev => {
      if (!drag) return;
      ev.preventDefault();
      const t = ev.target.closest('.th-step');
      if (!t || t === drag) return;
      const r = t.getBoundingClientRect();
      ol.insertBefore(drag, ev.clientY < r.top + r.height / 2 ? t : t.nextSibling);
    });
    ol.addEventListener('click', ev => {
      const b = ev.target.closest('button[data-mv]');
      if (!b || locked) return;
      const li = b.closest('.th-step'), d = Number(b.dataset.mv);
      if (d < 0 && li.previousElementSibling) ol.insertBefore(li, li.previousElementSibling);
      if (d > 0 && li.nextElementSibling) ol.insertBefore(li.nextElementSibling, li);
      b.focus();
    });
    return {
      ready: () => true,
      grade() {
        const c = cur();
        const inPlace = c.filter((v, k) => v === k).length;
        const ok = inPlace === n;
        return { ok, detail: ok ? '' : `${inPlace} of ${n} steps in the right place` };
      },
      reveal() {
        locked = true;
        [...ol.children].forEach((li, k) => {
          const i = Number(li.dataset.i), ok = i === k;
          li.draggable = false; li.classList.add(ok ? 'right' : 'wrong');
          li.querySelectorAll('button').forEach(b => { b.disabled = true; });
          const w = li.querySelector('.th-why');
          w.innerHTML = tag(ok ? 'right' : 'wrong', ok ? '✔ Right place' : `✘ Belongs at position ${i + 1}`) + ' ' + mdi(q.items[i].why);
          w.classList.remove('hidden');
        });
        if (!sameOrder(cur(), [...Array(n).keys()])) {
          const good = document.createElement('div');
          good.className = 'th-wrong-list';
          good.innerHTML = `<div class="th-sub">The correct order</div><ol class="th-correct-order">${q.items.map(it => `<li>${mdi(it.t)}</li>`).join('')}</ol>`;
          body.appendChild(good);
        }
      },
    };
  }

  // match + sort share one engine: chips (draggable) are placed on targets (slots or buckets)
  function buildPlacer(q, body, qEl, onChange) {
    const isMatch = q.type === 'match';
    const chips = isMatch
      ? [...q.pairs.map((p, i) => ({ id: 'r' + i, t: p.r, home: i })), ...(q.extras || []).map((d, j) => ({ id: 'x' + j, t: d.r, home: null, why: d.why }))]
      : q.items.map((it, i) => ({ id: 'c' + i, t: it.t, home: q.buckets.indexOf(it.bucket), why: it.why }));
    const targets = isMatch ? q.pairs.map((p, i) => ({ id: i, label: p.l, cap: 1 })) : q.buckets.map((b, i) => ({ id: i, label: b, cap: Infinity }));
    const bankOrder = shuffle(chips.map(c => c.id));
    const place = {};                 // chip id -> target id (absent = in the bank)
    let selected = null, locked = false, result = null;
    const chipById = id => chips.find(c => c.id === id);
    const inTarget = tid => chips.filter(c => place[c.id] === tid);

    function chipHtml(c) {
      const cls = ['th-chip', selected === c.id ? 'selected' : '', result && result[c.id] ? result[c.id] : ''].join(' ');
      return `<span class="${cls.trim()}" draggable="${locked ? 'false' : 'true'}" data-chip="${c.id}" tabindex="0" role="button">${mdi(c.t)}</span>`;
    }
    function render() {
      const bank = bankOrder.filter(id => place[id] === undefined).map(id => chipHtml(chipById(id))).join('');
      let html;
      if (isMatch) {
        html = `<div class="th-rows">${targets.map(t => `
          <div class="th-row"><div class="th-row-left">${mdi(t.label)}</div>
            <div class="th-slot${inTarget(t.id).length ? ' full' : ''}" data-target="${t.id}">${inTarget(t.id).map(chipHtml).join('') || '<span class="th-slot-hint">drop here</span>'}</div></div>`).join('')}</div>`;
      } else {
        html = `<div class="th-buckets" style="--cols:${targets.length}">${targets.map(t => `
          <div class="th-bucket" data-target="${t.id}"><div class="th-bucket-head">${mdi(t.label)}</div>
            <div class="th-bucket-drop">${inTarget(t.id).map(chipHtml).join('') || '<span class="th-slot-hint">drop here</span>'}</div></div>`).join('')}</div>`;
      }
      const showBank = !locked || bank;
      body.innerHTML = html + (showBank ? `<div class="th-bank" data-bank="1"><div class="th-sub">${locked ? 'Not matched to anything' : 'Items'}</div>${bank || '<span class="th-slot-hint">all placed</span>'}</div>` : '');
      onChange();
    }
    function put(chipId, tid) {
      if (tid === null) delete place[chipId];
      else {
        const t = targets[tid];
        const occ = inTarget(tid).filter(c => c.id !== chipId);
        if (occ.length >= t.cap) occ.forEach(c => { delete place[c.id]; });
        place[chipId] = tid;
      }
      selected = null;
      render();
    }
    let dragId = null;
    body.addEventListener('click', ev => {
      if (locked) return;
      const chip = ev.target.closest('[data-chip]');
      if (chip) {
        const id = chip.dataset.chip;
        if (place[id] !== undefined) put(id, null);            // a placed chip goes back to the bank
        else { selected = selected === id ? null : id; render(); }
        return;
      }
      const tgt = ev.target.closest('[data-target]');
      if (tgt && selected) put(selected, Number(tgt.dataset.target));
    });
    body.addEventListener('keydown', ev => {
      if ((ev.key === ' ' || ev.key === 'Enter') && ev.target.matches('[data-chip]') && !locked) { ev.preventDefault(); ev.stopPropagation(); ev.target.click(); }
    });
    body.addEventListener('dragstart', ev => {
      const chip = ev.target.closest('[data-chip]');
      if (!chip || locked) return ev.preventDefault();
      dragId = chip.dataset.chip; ev.dataTransfer.setData('text/plain', dragId); ev.dataTransfer.effectAllowed = 'move';
    });
    body.addEventListener('dragover', ev => {
      if (!dragId || locked) return;
      const t = ev.target.closest('[data-target],[data-bank]');
      if (t) { ev.preventDefault(); t.classList.add('over'); }
    });
    body.addEventListener('dragleave', ev => { const t = ev.target.closest('[data-target],[data-bank]'); if (t) t.classList.remove('over'); });
    body.addEventListener('drop', ev => {
      if (!dragId || locked) return;
      const tgt = ev.target.closest('[data-target]'), bank = ev.target.closest('[data-bank]');
      if (!tgt && !bank) return;
      ev.preventDefault();
      const id = dragId; dragId = null;
      put(id, tgt ? Number(tgt.dataset.target) : null);
    });
    body.addEventListener('dragend', () => { dragId = null; body.querySelectorAll('.over').forEach(e => e.classList.remove('over')); });
    render();

    const required = isMatch ? chips.filter(c => c.home !== null) : chips;
    return {
      ready: () => required.every(c => place[c.id] !== undefined),
      grade() {
        const right = required.filter(c => place[c.id] === c.home).length;
        // a wrongly placed distractor can never stay hidden: every slot is filled by exactly one chip
        const ok = right === required.length;
        return { ok, detail: ok ? '' : `${right} of ${required.length} placed right` };
      },
      reveal() {
        locked = true; selected = null;
        result = {};
        for (const c of chips) if (place[c.id] !== undefined) result[c.id] = place[c.id] === c.home ? 'right' : 'wrong';
        render();
        // explanations, one line per pair / item
        const lines = [];
        if (isMatch) {
          q.pairs.forEach((p, i) => {
            const got = chips.find(c => place[c.id] === i), ok = got && got.home === i;
            lines.push(`<div class="th-blank-row ${ok ? 'right' : 'wrong'}">${tag(ok ? 'right' : 'wrong', ok ? '✔ Correct' : '✘ Wrong')}
              ${mdi(p.l)} → <strong>${mdi(p.r)}</strong>${ok ? '' : ` <span class="hint">(you put: ${got ? mdi(got.t) : 'nothing'})</span>`}
              <div class="th-why">${mdi(p.why)}</div></div>`);
          });
          (q.extras || []).forEach(d => lines.push(`<div class="th-blank-row">${tag('rejected', '✘ Decoy')} ${mdi(d.r)}
            <div class="th-why">${mdi(d.why)}</div></div>`));
        } else {
          chips.forEach(c => {
            const ok = place[c.id] === c.home;
            lines.push(`<div class="th-blank-row ${ok ? 'right' : 'wrong'}">${tag(ok ? 'right' : 'wrong', ok ? '✔ Correct' : '✘ Wrong')}
              ${mdi(c.t)} → <strong>${mdi(q.buckets[c.home])}</strong>${ok ? '' : ` <span class="hint">(you put it under ${mdi(q.buckets[place[c.id]])})</span>`}
              <div class="th-why">${mdi(c.why)}</div></div>`);
          });
        }
        const box = document.createElement('div');
        box.className = 'th-wrong-list';
        box.innerHTML = `<div class="th-sub">Why</div>${lines.join('')}`;
        body.appendChild(box);
      },
    };
  }

  const BUILDERS = { single: buildChoice, multi: buildChoice, fill: buildFill, order: buildOrder, match: buildPlacer, sort: buildPlacer };

  return { load, collection, renderHomeGrid, renderSidebar, open, hide };
})();
