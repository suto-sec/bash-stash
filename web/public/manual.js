// bash stash — the Reference manual. One entry per command / syntax / file, written like a good man page:
// synopsis, description, every option, worked examples (run for real by tools/build_manual.js: their output is in
// manual-outputs.json), exit status, pitfalls, see also. Entries live in manual-<category>.js files that call MANUAL.add().
//
// Entry fields (all optional except name and summary):
//   name, key (default: lower-case name), kind: 'builtin' | 'command' | 'syntax' | 'file' | 'concept',
//   aliases: [tokens that should lead here, e.g. exercise "Commands:" tokens such as '-exec {} +'],
//   summary: one line (also shown in the exercise Info panel),
//   synopsis: [usage lines], desc: [paragraphs; "- " lines make a list],
//   options: [{ title?, items: [{ flag, desc }] }] (or a flat list of { flag, desc }),
//   examples: [{ title, cmd, note?, out? (only for norun), norun?, fails? }],
//   sections: [{ title, body?: [paragraphs], table?: [[head...], [cell...]...], code? }],
//   exit: [lines], notes: [pitfalls], see: [keys].
'use strict';
const MANUAL = (() => {
  const CATS = [
    ['help', 'Getting help'], ['files', 'Files and directories'], ['archives', 'Archives and compression'],
    ['text', 'Viewing and transforming text'], ['search', 'Searching and patterns'], ['perms', 'Permissions and ownership'],
    ['users', 'Users, groups and sessions'], ['procs', 'Processes and jobs'], ['redir', 'Redirection and pipes'],
    ['expand', 'Variables and expansions'], ['script', 'Scripting'], ['patterns', 'Script patterns'],
    ['system', 'System, services and boot'], ['util', 'Small utilities'],
  ];
  const entries = new Map();
  const alias = new Map();
  let outputs = {};
  const norm = s => String(s).trim().toLowerCase();
  const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));

  function add(cat, list) {
    for (const e of list) {
      e.cat = cat;
      e.key = norm(e.key || e.name);
      entries.set(e.key, e);
      for (const a of e.aliases || []) alias.set(norm(a), e.key);
    }
  }
  const get = key => entries.get(norm(key)) || (alias.has(norm(key)) ? entries.get(alias.get(norm(key))) : null);
  const all = () => [...entries.values()];
  const byCat = cat => all().filter(e => e.cat === cat).sort((a, b) => a.name.localeCompare(b.name, 'en', { sensitivity: 'base' }));
  const catTitle = id => (CATS.find(c => c[0] === id) || [id, id])[1];
  const setOutputs = o => { outputs = o || {}; };

  // pattern rules for tokens that are syntax rather than words (manual-rules.js): [regex, key]
  const rules = [];
  const rule = (re, key) => rules.push([re, norm(key)]);

  // token (as written in an exercise's "Commands:" line) -> entry or null
  function lookup(token) {
    const t = norm(token);
    if (entries.has(t)) return entries.get(t);
    if (alias.has(t)) return entries.get(alias.get(t));
    const b = norm((t.match(/^\S+/) || [t])[0]);
    if (entries.has(b)) return entries.get(b);
    if (alias.has(b)) return entries.get(alias.get(b));
    for (const [re, key] of rules) if (re.test(String(token).trim()) && entries.has(key)) return entries.get(key);
    return null;
  }

  // text with `code` and **bold**
  // `code`, ``code with `backticks` inside`` and **bold**; code spans are lifted out first so that `**` or `*` inside code never starts a bold
  function inline(src) {
    const codes = [];
    const lift = (m, c) => { codes.push(c); return `\u0002${codes.length - 1}\u0003`; };
    return esc(src).replace(/`` ` ``/g, () => lift(0, '`')).replace(/``\s?(.+?)\s?``/g, lift).replace(/`([^`]+)`/g, lift)
      .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>').replace(/\u0002(\d+)\u0003/g, (m, n) => `<code>${codes[n]}</code>`);
  }
  function paras(list) {
    return (list || []).map(p => {
      const lines = String(p).split('\n');
      if (lines.every(l => /^\s*- /.test(l))) return `<ul>${lines.map(l => `<li>${inline(l.replace(/^\s*- /, ''))}</li>`).join('')}</ul>`;
      return `<p>${lines.map(inline).join('<br>')}</p>`;
    }).join('');
  }
  function table(rows) {
    if (!rows || !rows.length) return '';
    const [head, ...body] = rows;
    return `<table class="man-table"><thead><tr>${head.map(h => `<th>${inline(h)}</th>`).join('')}</tr></thead><tbody>${body.map(r => `<tr>${r.map(c => `<td>${inline(c)}</td>`).join('')}</tr>`).join('')}</tbody></table>`;
  }
  const KIND = { builtin: 'shell builtin', command: 'command', syntax: 'shell syntax', file: 'file', concept: 'concept' };

  function entryHTML(e) {
    const secs = [];   // [id, title, html]
    if (e.synopsis && e.synopsis.length) secs.push(['syn', 'Synopsis', `<pre class="man-syn">${e.synopsis.map(esc).join('\n')}</pre>`]);
    if (e.desc && e.desc.length) secs.push(['desc', 'Description', paras(e.desc)]);
    const groups = (e.options || []).length && e.options[0].flag !== undefined ? [{ items: e.options }] : (e.options || []);
    if (groups.length) {
      secs.push(['opt', 'Options', groups.map(g => `${g.title ? `<h3>${inline(g.title)}</h3>` : ''}<dl class="man-opts">${g.items.map(o =>
        `<dt>${o.flag.split(/\s*\|\|\s*/).map(f => `<code>${esc(f)}</code>`).join(' ')}</dt><dd>${inline(o.desc)}</dd>`).join('')}</dl>`).join('')]);
    }
    for (const s of (e.sections || []).filter(s => !s.after)) secs.push([`s-${esc(norm(s.title)).replace(/\W+/g, '-')}`, s.title, sectionBody(s)]);
    if (e.examples && e.examples.length) {
      secs.push(['ex', 'Examples', e.examples.map((x, i) => {
        const out = x.norun ? x.out : outputs[`${e.key}#${i}`];
        return `<div class="man-ex"><h3>${inline(x.title || 'Example')}</h3>
          <pre class="man-cmd">${esc(x.cmd).split('\n').map((l, k) => (k === 0 ? '$ ' : '  ') + l).join('\n')}</pre>
          ${out ? `<pre class="man-out">${esc(out)}</pre>` : ''}${x.note ? paras([x.note]) : ''}</div>`;
      }).join('')]);
    }
    for (const s of (e.sections || []).filter(s => s.after)) secs.push([`s-${esc(norm(s.title)).replace(/\W+/g, '-')}`, s.title, sectionBody(s)]);
    if (e.exit && e.exit.length) secs.push(['exit', 'Exit status', paras(e.exit)]);
    if (e.notes && e.notes.length) secs.push(['notes', 'Notes and common mistakes', paras(e.notes.map(n => `- ${n}`).join('\n').split('\n\n'))]);
    if (e.see && e.see.length) secs.push(['see', 'See also', `<p class="man-see">${e.see.map(k => get(k) ? `<a href="#" data-goto-cmd="${esc(get(k).key)}"><code>${esc(get(k).name)}</code></a>` : `<code>${esc(k)}</code>`).join(' · ')}</p>`]);
    const toc = secs.map(([id, t]) => `<a href="#" data-man-jump="m-${id}">${esc(t)}</a>`).join('');
    return `<article class="man" data-key="${esc(e.key)}">
      <header class="man-head"><h1><code>${esc(e.name)}</code></h1>${e.kind ? `<span class="man-kind">${KIND[e.kind] || e.kind}</span>` : ''}<span class="man-cat">${esc(catTitle(e.cat))}</span>
        <p class="man-sum">${inline(e.summary || '')}</p><nav class="man-toc">${toc}</nav></header>
      ${secs.map(([id, t, html]) => `<section class="man-sec" id="m-${id}"><h2>${esc(t)}</h2>${html}</section>`).join('')}
    </article>`;
  }
  function sectionBody(s) {
    return paras(s.body) + table(s.table) + (s.code ? `<pre class="man-syn">${esc(s.code)}</pre>` : '');
  }

  // a compact card (Info panel, category lists)
  function cardHTML(e, linkify = true) {
    const inner = `<code>${esc(e.name)}</code><p>${inline(e.summary || e.desc || '')}</p>${e.synopsis && e.synopsis[0] ? `<span class="gl-syn">${esc(e.synopsis[0])}</span>` : ''}`;
    return linkify ? `<a href="#" class="gl-item" data-goto-cmd="${esc(e.key)}">${inner}</a>` : `<div class="gl-item">${inner}</div>`;
  }
  const searchText = e => norm([e.name, e.summary, ...(e.aliases || []), ...(e.synopsis || [])].join(' '));

  return { CATS, add, get, all, byCat, catTitle, lookup, rule, entryHTML, cardHTML, inline, setOutputs, searchText, esc };
})();
