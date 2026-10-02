// Keyboard shortcuts and the Ctrl+K palette.
//   Ctrl+K (Cmd+K)   search every exercise, script, exam, quiz and manual entry. Enter opens the result where the setting says
//                    (a new tab that is brought to the front, or this tab); Shift+Enter does the opposite.
//   Alt+G            the "go to" mode: a panel lists the keys, then ONE plain key does the job (h r s t i c x q e n p f ? k);
//                    the places (h r s t i c x q e) open like the search results, with their own setting.
// Safety rules (a plain letter must never navigate by accident, e.g. typing after the focus was lost from VS Code):
//   - the only keys that start something are Ctrl/Cmd+K and Alt+G; plain letters act only inside the go-to mode, which is a visible panel
//     that Esc, a click, any other key, losing the window focus or 6 seconds cancel;
//   - nothing starts while the focus is inside the terminal (readline owns Ctrl+K and the Alt keys) or in a script practice exam that
//     grades only on submit (no Reference there); VS Code's iframe never sends its keys here;
//   - AltGr (Ctrl+Alt on Windows) and dead keys (accents) are ignored, so Spanish text and symbols never trigger anything;
//   - every action says in a small toast what it did, or why it did nothing.
'use strict';
const Keys = (() => {
  const strict = () => document.body.classList.contains('sexam-strict');
  const shown = el => !!el && el.offsetParent !== null;
  const inTerminal = t => !!t && !!t.closest && !!t.closest('.xterm');
  const inField = t => !!t && (t.isContentEditable || /^(INPUT|TEXTAREA|SELECT)$/.test(t.tagName));
  const mac = /Mac|iPhone|iPad/.test(navigator.platform || '');
  const e$ = id => document.getElementById(id);

  // where things open: a new tab that gets the focus (default) or this tab; one setting for the palette, one for the go-to mode
  const PREF = { palette: 'keysPaletteTab', mode: 'keysModeTab' };
  const newTab = which => { try { return localStorage.getItem(PREF[which]) !== 'same'; } catch { return true; } };
  const syncPrefs = () => { Seg.set('palettetab', newTab('palette') ? 'new' : 'same'); Seg.set('modetab', newTab('mode') ? 'new' : 'same'); footer(); };
  for (const [which, key] of [['palette', 'palettetab'], ['mode', 'modetab']]) Seg.on(key, v => { try { localStorage.setItem(PREF[which], v === 'same' ? 'same' : 'new'); } catch { /* private mode */ } syncPrefs(); });

  // ---------------------------------------------------------------- feedback
  const toastEl = document.createElement('div');
  toastEl.className = 'keys-toast hidden';
  toastEl.setAttribute('role', 'status');
  document.body.appendChild(toastEl);
  let toastTimer = 0;
  function toast(text) {
    toastEl.textContent = text;
    toastEl.classList.remove('hidden');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toastEl.classList.add('hidden'), 2200);
  }

  // ---------------------------------------------------------------- where the keys go
  function whenShown(find, fn, tries = 25) {
    const t = setInterval(() => { const el = find(); if (shown(el)) { clearInterval(t); fn(el); } else if (--tries <= 0) clearInterval(t); }, 80);
  }
  function goHome(sectionId) {
    if (typeof Home !== 'undefined') Home.expandById(sectionId);                         // a folded section opens
    const scroll = () => { const el = e$(sectionId); if (shown(el)) { el.scrollIntoView({ block: 'start' }); return true; } return false; };
    if (location.hash === '#/home' && scroll()) return;
    location.hash = '#/home';
    whenShown(() => e$(sectionId), el => { if (typeof Home !== 'undefined') Home.expandById(sectionId); el.scrollIntoView({ block: 'start' }); });
  }
  function openSettings() {
    const open = () => { const b = e$('settings-btn'); if (b && e$('settings-menu').classList.contains('hidden')) b.click(); };
    if (shown(e$('settings-btn')) && !location.hash.startsWith('#/reference')) return open();   // the reference page has its own header
    location.hash = '#/home';
    whenShown(() => e$('settings-btn'), open);
  }
  // [key, label, id used in ?go=, what it does]
  const PLACES = [
    ['h', 'Home', 'home', () => { location.hash = '#/home'; }],
    ['r', 'Reference manual', 'reference', () => { location.hash = '#/reference'; }],
    ['s', 'Settings', 'settings', openSettings],
    ['t', 'Tracks', 'tracks', () => goHome('home-sec-tracks')],
    ['i', 'Introduction', 'intro', () => goHome('home-sec-intro')],
    ['c', 'Scripts', 'scripts', () => goHome('home-sec-scripts')],
    ['x', 'Script practice exams', 'sexams', () => goHome('home-sec-sexams')],
    ['q', 'Theory quizzes', 'quizzes', () => goHome('theory-quizzes-title')],
    ['e', 'Theory practice exams', 'exams', () => goHome('theory-exams-title')],
    ['m', 'Man page drills', 'man', () => goHome('man-home-title')],
    ['d', 'Exam readiness', 'readiness', () => { location.hash = '#/readiness'; }],
  ];
  const step = delta => {
    const b = e$(delta > 0 ? 'next-btn' : 'prev-btn');
    if (shown(b) && !b.disabled) { b.click(); toast(delta > 0 ? 'Next exercise / step' : 'Previous exercise / step'); }
    else toast('Next and previous only work inside an exercise or a script');
  };
  const focusFilter = () => {
    const box = ['home-search', 'reference-search', 'search'].map(e$).find(shown);
    if (box) { box.focus(); box.select && box.select(); toast('Filter focused'); } else toast('There is no filter on this page');
  };
  // what each key of the go-to mode does
  const MODE = [
    ...PLACES.map(([k, label, id, run]) => [k, label, () => {
      if (newTab('mode')) { openUrl(placeUrl(id, k), true); toast(`Opening ${label} in a new tab`); }
      else { run(); toast(`Go to: ${label}`); }
    }]),
    ['n', 'Next exercise / script step', () => step(1)],
    ['p', 'Previous exercise / script step', () => step(-1)],
    ['f', 'Focus the filter of this page', focusFilter],
    ['k', 'Search everything (also Ctrl+K)', () => openPalette()],
    ['?', 'This list', () => openHelp()],
  ];

  // a new tab brought to the front (this runs inside the key press / click, so the browser allows it); blocked -> this tab
  function openUrl(url, inNewTab) {
    if (!inNewTab) { location.href = url; return; }
    const w = window.open(url, '_blank');
    if (w) { try { w.opener = null; w.focus(); } catch { /* cross-origin never */ } }
    else { toast('The browser blocked the new tab: opened here'); location.href = url; }
  }
  function footer() {
    const f = e$('pal-foot');
    if (f) f.textContent = `↑ ↓ move · Enter opens it in ${newTab('palette') ? 'a new tab' : 'this tab'} · Shift+Enter ${newTab('palette') ? 'here' : 'in a new tab'} · Esc close`;
  }

  // ---------------------------------------------------------------- overlays (palette and help share the frame)
  const overlay = document.createElement('div');
  overlay.id = 'keys-overlay';
  overlay.className = 'keys-overlay hidden';
  overlay.innerHTML = `<div class="keys-box" role="dialog" aria-modal="true">
    <div id="keys-palette" class="hidden">
      <input id="pal-q" type="text" autocomplete="off" spellcheck="false" placeholder="Search exercises, scripts, exams, quizzes and the manual…" aria-label="Search">
      <div id="pal-list" role="listbox"></div>
      <div class="keys-foot" id="pal-foot"></div>
    </div>
    <div id="keys-help" class="hidden"></div>
  </div>`;
  document.body.appendChild(overlay);
  const pal = e$('keys-palette'), help = e$('keys-help'), input = e$('pal-q'), list = e$('pal-list');
  const isOpen = () => !overlay.classList.contains('hidden');
  let returnFocus = null;
  function openOverlay(which) {
    if (!isOpen()) returnFocus = document.activeElement;
    overlay.classList.remove('hidden');
    pal.classList.toggle('hidden', which !== 'palette');
    help.classList.toggle('hidden', which !== 'help');
  }
  function closeOverlay() {
    overlay.classList.add('hidden');
    if (returnFocus && returnFocus.focus && document.contains(returnFocus)) returnFocus.focus();
  }
  overlay.addEventListener('mousedown', ev => { if (ev.target === overlay) closeOverlay(); });

  function openHelp() {
    const row = (k, d) => `<tr><td>${k.map(x => `<kbd>${x}</kbd>`).join(' ')}</td><td>${d}</td></tr>`;
    help.innerHTML = `<h2>Keyboard shortcuts</h2>
      <table class="keys-table">
        <tr><th colspan="2">Search</th></tr>
        ${row(['Ctrl', 'K'], 'Search every exercise, script, exam, quiz and manual entry')}
        ${row(['Enter'], 'in the search: open the result (new tab or this tab: see Settings)')}
        ${row(['Shift', 'Enter'], 'in the search: open it the other way')}
        <tr><th colspan="2">Go to: press <kbd>Alt</kbd> <kbd>G</kbd>, then one key</th></tr>
        ${MODE.map(([k, label]) => row([k], label)).join('')}
        <tr><th colspan="2">Other</th></tr>
        ${row(['Ctrl', 'Enter'], 'Check the exercise')}
        ${row(['Esc'], 'Close / cancel')}
      </table>
      <p class="hint">Plain letters never do anything by themselves, so a stray key cannot move you around. Shortcuts do not start while the
      focus is in the terminal (the shell keeps <kbd>Ctrl</kbd> <kbd>K</kbd> and the <kbd>Alt</kbd> keys) or in VS Code: click on the page first.
      They are also off in a script practice exam that grades only on submit.</p>`;
    openOverlay('help');
  }

  // ---------------------------------------------------------------- the palette
  const RECENT = 'paletteRecent';
  const recent = () => { try { return JSON.parse(localStorage.getItem(RECENT)) || []; } catch { return []; } };
  const remember = href => { try { localStorage.setItem(RECENT, JSON.stringify([href, ...recent().filter(h => h !== href)].slice(0, 6))); } catch { /* private mode */ } };
  const base = () => location.origin + location.pathname;
  const placeUrl = (id, key) => key === 'h' ? base() + '#/home' : key === 'r' ? base() + '#/reference' : key === 'd' ? base() + '#/readiness' : `${base()}?go=${id}#/home`;
  function items() {
    const out = [];
    const add = (kind, title, hint, href, text, status) => out.push({ kind, title, hint, url: base() + href, href, status, hay: `${title} ${text || ''} ${hint || ''}`.toLowerCase() });
    for (const [k, label, id] of PLACES) out.push({ kind: 'Go to', title: label, hint: `Alt+G ${k}`, href: placeUrl(id, k), url: placeUrl(id, k), hay: `${label} go to ${k}`.toLowerCase() });
    out.push({ kind: 'Help', title: 'Keyboard shortcuts', hint: 'Alt+G ?', href: '', run: openHelp, hay: 'keyboard shortcuts keys help' });
    for (const e of state.flat || []) add('Exercise', `${e.id} · ${e.title}`, e.cmds || '', `#/ex/${e.id}`, `${e.id} ${e.cmds || ''}`, e.status);
    for (const e of Scripts.list()) add('Script', `${e.id.slice(1)} · ${e.title}`, `${e.script} · ${e.steps.length} steps`, `#/script/${e.id}`, `${e.id} ${e.script} ${e.cmds} ${(e.tags || []).join(' ')}`, e.status);
    for (const e of SExams.list()) add('Practice exam', e.title, SExams.tierLabel(e.tier), `#/sexam/${e.id}`, `${e.id} ${e.cmds || ''}`, SExams.statusOf(e));
    for (const e of Exams.list()) add('Theory exam', e.title, Exams.tierLabel(e.tier), `#/exam/${e.id}`, e.id, Exams.statusOf(e));
    for (const c of Theory.list()) {
      const next = ((c.groups || []).flatMap(g => g.questions).find(q => q.status !== 'pass') || (c.groups[0] || { questions: [{}] }).questions[0] || {}).id;
      add('Quiz', c.title, '', `#/theory/${c.id}${next ? '/' + next : ''}`, c.about || '');
    }
    if (!strict()) for (const m of MANUAL.all()) add('Reference', m.name, m.summary || '', `#/reference/cmd/${encodeURIComponent(m.key)}`, `${m.key} ${(m.aliases || []).join(' ')}`);
    return out;
  }
  // every word of the query has to match; words at the start of a word score best, then substrings, then scattered letters
  function score(it, words) {
    let total = 0;
    for (const w of words) {
      const i = it.hay.indexOf(w);
      if (i >= 0) { total += (i === 0 || /[\s·_./-]/.test(it.hay[i - 1])) ? 1 : 3; total += i / 200; continue; }
      let j = 0;
      for (const ch of it.hay) if (ch === w[j] && ++j === w.length) break;
      if (j < w.length) return Infinity;
      total += 8;
    }
    const t = it.title.toLowerCase();
    if (t === words[0]) total -= 4; else if (t.startsWith(words[0])) total -= 2;   // typing a command name finds its manual entry first
    return total + it.title.length / 400;
  }
  let all = [], shownItems = [], sel = 0;
  const esc2 = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  function render() {
    const q = input.value.trim().toLowerCase();
    if (!q) {
      const byHref = new Map(all.filter(i => i.href && !i.run).map(i => [i.href, i]));
      shownItems = [...recent().map(h => byHref.get(h)).filter(Boolean), ...all.filter(i => i.kind === 'Go to' || i.kind === 'Help')];
    } else {
      const words = q.split(/\s+/);
      shownItems = all.map(i => [score(i, words), i]).filter(([s]) => s !== Infinity).sort((a, b) => a[0] - b[0]).slice(0, 60).map(x => x[1]);
    }
    sel = Math.min(sel, Math.max(0, shownItems.length - 1));
    list.innerHTML = shownItems.length ? shownItems.map((i, n) => {
      const dot = i.status ? `<span class="dot ${i.status}">${(STATUS[i.status] || STATUS.new).dot}</span>` : '<span class="dot"></span>';
      return `<div class="pal-item${n === sel ? ' sel' : ''}" data-n="${n}" role="option">${dot}<span class="pal-kind">${esc2(i.kind)}</span>
        <span class="pal-title">${esc2(i.title)}</span><span class="pal-hint">${esc2(i.hint || '')}</span></div>`;
    }).join('') : '<p class="hint" style="padding:14px">Nothing matches.</p>';
    const cur = list.querySelector('.sel');
    if (cur) cur.scrollIntoView({ block: 'nearest' });
  }
  function openPalette() {
    if (strict()) { toast('The search is off in an exam that grades only on submit'); return; }
    all = items(); input.value = ''; sel = 0;
    openOverlay('palette'); render();
    input.focus();
  }
  function choose(n, invert) {
    const it = shownItems[n];
    if (!it) return;
    if (it.run) { closeOverlay(); it.run(); return; }
    remember(it.href);
    closeOverlay();
    openUrl(it.url, newTab('palette') !== !!invert);
  }
  input.addEventListener('input', () => { sel = 0; render(); });
  input.addEventListener('keydown', ev => {
    if (ev.key === 'ArrowDown') { ev.preventDefault(); sel = Math.min(shownItems.length - 1, sel + 1); render(); }
    else if (ev.key === 'ArrowUp') { ev.preventDefault(); sel = Math.max(0, sel - 1); render(); }
    else if (ev.key === 'Enter' && !ev.isComposing) { ev.preventDefault(); choose(sel, ev.shiftKey); }
  });
  list.addEventListener('click', ev => {
    const a = ev.target.closest('.pal-item');
    if (a) choose(Number(a.dataset.n), ev.shiftKey);
  });
  list.addEventListener('mousemove', ev => {
    const a = ev.target.closest('.pal-item');
    if (a && Number(a.dataset.n) !== sel) { const old = list.querySelector('.sel'); if (old) old.classList.remove('sel'); sel = Number(a.dataset.n); a.classList.add('sel'); }
  });

  // ---------------------------------------------------------------- the go-to mode
  const modeEl = document.createElement('div');
  modeEl.className = 'keys-mode hidden';
  modeEl.innerHTML = `<div class="keys-mode-title">Go to… <span class="hint">press a key (Esc cancels)</span></div><div class="keys-mode-grid">${
    MODE.map(([k, label]) => `<span><kbd>${k}</kbd> ${label}</span>`).join('')}</div>`;
  document.body.appendChild(modeEl);
  let modeOn = false, modeTimer = 0;
  const endMode = () => { modeOn = false; clearTimeout(modeTimer); modeEl.classList.add('hidden'); };
  function startMode() {
    modeOn = true; modeEl.classList.remove('hidden');
    clearTimeout(modeTimer); modeTimer = setTimeout(endMode, 6000);
  }
  window.addEventListener('blur', endMode);
  document.addEventListener('mousedown', () => { if (modeOn) endMode(); }, true);

  // ---------------------------------------------------------------- the keys
  const isAltOnly = ev => ev.altKey && !ev.ctrlKey && !ev.metaKey && !(ev.getModifierState && ev.getModifierState('AltGraph'));
  document.addEventListener('keydown', ev => {
    if (ev.isComposing || ev.key === 'Dead' || ev.key === 'Process') return;       // accents and IMEs
    if (ev.key === 'Escape') {
      if (isOpen()) { ev.preventDefault(); closeOverlay(); }
      if (modeOn) { ev.preventDefault(); endMode(); }
      return;
    }
    if (['Shift', 'Alt', 'Control', 'Meta', 'AltGraph', 'CapsLock'].includes(ev.key)) return;
    // inside the mode: one plain key decides (it is not typed anywhere)
    if (modeOn) {
      const hit = !ev.ctrlKey && !ev.metaKey && !ev.altKey && MODE.find(([k]) => k === (ev.key === '/' ? '?' : ev.key.toLowerCase()));
      endMode();
      ev.preventDefault(); ev.stopPropagation();
      if (hit) { if (isOpen()) closeOverlay(); hit[2](); }
      else toast('Cancelled');
      return;
    }
    if (ev.target && inTerminal(ev.target)) return;                                   // readline owns Ctrl+K and the Alt keys
    const k = ev.key.toLowerCase();
    // Ctrl/Cmd+K: the palette (again: closes it)
    if ((ev.ctrlKey || ev.metaKey) && !ev.altKey && !ev.shiftKey && k === 'k') {
      ev.preventDefault();
      if (isOpen()) closeOverlay(); else openPalette();
      return;
    }
    // Alt+G: the go-to mode (also from the open palette, which it closes). On a Mac Option+G types a character: not in other fields.
    if (isAltOnly(ev) && ev.code === 'KeyG') {
      if (mac && inField(ev.target) && ev.target !== input) return;
      if (strict()) { toast('Shortcuts are off in an exam that grades only on submit'); ev.preventDefault(); return; }
      if (document.querySelector('dialog[open]')) return;
      ev.preventDefault();
      if (isOpen()) closeOverlay();
      startMode();
    }
  }, true);

  // `?go=tracks` etc.: a tab opened by the palette on a place of the home page
  (function boot() {
    const go = new URLSearchParams(location.search).get('go');
    if (!go) return;
    history.replaceState(null, '', location.pathname + (location.hash || '#/home'));
    const hit = PLACES.find(p => p[2] === go);
    if (hit) whenShown(() => e$('home-body') || e$('main'), () => hit[3](), 60);
  })();

  // the visible entry points
  for (const id of ['palette-btn', 'home-palette-btn', 'readiness-palette-btn']) { const b = e$(id); if (b) b.onclick = openPalette; }
  // the same as pressing Alt+G (and the same refusals)
  function goMode() {
    if (strict()) { toast('Shortcuts are off in an exam that grades only on submit'); return; }
    if (document.querySelector('dialog[open]')) return;
    if (isOpen()) closeOverlay();
    startMode();
  }
  for (const id of ['go-btn', 'home-go-btn', 'readiness-go-btn']) { const b = e$(id); if (b) { b.onclick = goMode; if (mac) b.querySelector('kbd').textContent = '⌥ G'; } }
  const hb = e$('shortcuts-row');
  if (hb) hb.onclick = () => { e$('settings-menu').classList.add('hidden'); e$('settings-btn').setAttribute('aria-expanded', 'false'); openHelp(); };
  syncPrefs();
  return { openPalette, openHelp, toast, openUrl, refUrl: key => `${base()}#/reference/cmd/${encodeURIComponent(key)}` };
})();
