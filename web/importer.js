// bash stash — importing content packs. A pack is ONE json file:
//   { "format": "bash-stash-pack", "version": 1, "id": "my-pack", "title": "...", "description": "...", "items": [ ... ] }
// Items (phase 1): { "kind": "quiz", ... } and { "kind": "exam", ... } (data only: nothing in them is ever executed).
// validatePack() checks a parsed pack and returns the normalized copy (only known fields, trimmed strings) together with every
// problem found, each with the place where it is, so the page can show "item 2 > group 1 > question 3: the right option is missing".
// The format is described for humans (and for LLMs) in web/import-prompt.md; keep the two in step.
'use strict';

const SLUG = /^[a-z0-9][a-z0-9-]{0,39}$/;
const KINDS = ['quiz', 'exam'];                       // phase 1; exercise / script / scriptexam come later
const TYPES = ['single', 'multi', 'fill', 'order', 'match', 'sort'];
const LIMITS = { items: 100, groups: 30, questions: 200, text: 4000, short: 200, opt: 1200 };

function validatePack(raw) {
  const errors = [], warnings = [];
  const err = (at, msg) => errors.push({ at, msg });
  const warn = (at, msg) => warnings.push({ at, msg });
  const isObj = v => v && typeof v === 'object' && !Array.isArray(v);
  const str = (v, at, what, { max = LIMITS.short, required = true } = {}) => {
    if (v === undefined || v === null || v === '') { if (required) err(at, `${what} is missing`); return ''; }
    if (typeof v !== 'string') { err(at, `${what} must be text`); return ''; }
    const s = v.trim();
    if (!s && required) { err(at, `${what} is empty`); return ''; }
    if (s.length > max) { err(at, `${what} is too long (${s.length} characters, at most ${max})`); return s.slice(0, max); }
    return s;
  };
  const slug = (v, at, what) => {
    if (typeof v !== 'string' || !SLUG.test(v)) { err(at, `${what} must be a short lowercase identifier (a-z, 0-9 and "-", starting with a letter or digit, at most 40 characters), got ${JSON.stringify(v)}`); return ''; }
    return v;
  };
  const arr = (v, at, what, { min = 0, max = 1000 } = {}) => {
    if (!Array.isArray(v)) { err(at, `${what} must be a list`); return []; }
    if (v.length < min) err(at, `${what} needs at least ${min} entries, it has ${v.length}`);
    if (v.length > max) { err(at, `${what} has too many entries (${v.length}, at most ${max})`); return v.slice(0, max); }
    return v;
  };
  const why = (v, at) => {
    const s = typeof v === 'string' ? v.trim() : '';
    if (!s) warn(at, 'has no explanation ("why"): the learner will get no feedback for it');
    return s.slice(0, LIMITS.opt);
  };

  // ---------------------------------------------------------------- questions
  function question(q, at) {
    if (!isObj(q)) { err(at, 'a question must be an object'); return null; }
    const type = q.type;
    if (!TYPES.includes(type)) { err(at, `type must be one of ${TYPES.join(', ')}, got ${JSON.stringify(type)}`); return null; }
    const out = { type, id: slug(q.id, at, 'id'), title: str(q.title, at, 'title'), text: str(q.text, at, 'text', { max: LIMITS.text }) };
    at = `${at} (${out.title || out.id || type})`;
    const note = str(q.note, at, 'note', { max: LIMITS.text, required: type === 'fill' });
    if (note) out.note = note;
    if (type === 'single' || type === 'multi') {
      const opts = arr(q.options, at, 'options', { min: 3, max: 8 }).map((o, i) => {
        const oa = `${at} › option ${i + 1}`;
        if (!isObj(o)) { err(oa, 'an option must be an object {t, ok, why}'); return null; }
        return { t: str(o.t, oa, 't (the option text)', { max: LIMITS.opt }), ok: o.ok === true, why: why(o.why, oa) };
      }).filter(Boolean);
      const right = opts.filter(o => o.ok).length;
      if (type === 'single' && right !== 1) err(at, `a single-choice question needs exactly one option with "ok": true, it has ${right}`);
      if (type === 'multi' && (right < 2 || right === opts.length)) err(at, `a multiple-choice question needs at least two right options and at least one wrong one (it has ${right} right of ${opts.length})`);
      if (type === 'single' && opts.length > 7) err(at, 'a single-choice question has at most 7 options');
      if (new Set(opts.map(o => o.t)).size !== opts.length) err(at, 'two options have the same text');
      out.options = opts;
    } else if (type === 'fill') {
      const blanks = arr(q.blanks, at, 'blanks', { min: 1, max: 6 }).map((b, i) => {
        const ba = `${at} › blank ${i}`;
        const answers = isObj(b) ? arr(b.answers, ba, 'answers', { min: 1, max: 8 }).map(a => str(a, ba, 'an accepted answer', { max: 100 })).filter(Boolean) : [];
        if (!isObj(b)) err(ba, 'a blank must be an object {answers: [...]}');
        return { answers };
      });
      const used = [...out.text.matchAll(/\{\{(\d+)\}\}/g)].map(m => Number(m[1]));
      for (let i = 0; i < blanks.length; i++) if (!used.includes(i)) err(at, `the text has no {{${i}}} for blank ${i}`);
      for (const n of new Set(used)) if (n >= blanks.length) err(at, `the text uses {{${n}}} but there are only ${blanks.length} blanks`);
      out.blanks = blanks;
      out.wrong = (q.wrong === undefined ? [] : arr(q.wrong, at, 'wrong', { max: 8 })).map((w, i) => {
        const wa = `${at} › wrong answer ${i + 1}`;
        if (!isObj(w)) { err(wa, 'must be an object {a, why}'); return null; }
        return { a: str(w.a, wa, 'a (the wrong answer)', { max: 100 }), why: why(w.why, wa) };
      }).filter(Boolean);
      if (!out.wrong.length) warn(at, 'lists no typical wrong answers ("wrong"): a wrong answer will get no specific feedback');
    } else if (type === 'order') {
      out.items = arr(q.items, at, 'items', { min: 3, max: 8 }).map((o, i) => {
        const oa = `${at} › step ${i + 1}`;
        if (!isObj(o)) { err(oa, 'a step must be an object {t, why}'); return null; }
        return { t: str(o.t, oa, 't (the step)', { max: LIMITS.opt }), why: why(o.why, oa) };
      }).filter(Boolean);
      if (new Set(out.items.map(o => o.t)).size !== out.items.length) err(at, 'two steps have the same text');
    } else if (type === 'match') {
      out.pairs = arr(q.pairs, at, 'pairs', { min: 3, max: 8 }).map((p, i) => {
        const pa = `${at} › pair ${i + 1}`;
        if (!isObj(p)) { err(pa, 'a pair must be an object {l, r, why}'); return null; }
        return { l: str(p.l, pa, 'l (left side)', { max: LIMITS.opt }), r: str(p.r, pa, 'r (right side)', { max: LIMITS.opt }), why: why(p.why, pa) };
      }).filter(Boolean);
      if (new Set(out.pairs.map(p => p.l)).size !== out.pairs.length) err(at, 'two pairs have the same left side');
      if (new Set(out.pairs.map(p => p.r)).size !== out.pairs.length) err(at, 'two pairs have the same right side (the learner could not tell them apart)');
      if (q.extras !== undefined) {
        out.extras = arr(q.extras, at, 'extras', { max: 4 }).map((x, i) => {
          const xa = `${at} › extra ${i + 1}`;
          if (!isObj(x)) { err(xa, 'must be an object {r, why}'); return null; }
          const r = str(x.r, xa, 'r (the decoy)', { max: LIMITS.opt });
          if (out.pairs.some(p => p.r === r)) err(xa, 'a decoy repeats a right side of a pair');
          return { r, why: why(x.why, xa) };
        }).filter(Boolean);
      }
    } else if (type === 'sort') {
      const buckets = arr(q.buckets, at, 'buckets', { min: 2, max: 4 }).map(b => str(b, at, 'a bucket name', { max: 60 })).filter(Boolean);
      if (new Set(buckets).size !== buckets.length) err(at, 'two buckets have the same name');
      out.buckets = buckets;
      out.items = arr(q.items, at, 'items', { min: 4, max: 10 }).map((o, i) => {
        const oa = `${at} › item ${i + 1}`;
        if (!isObj(o)) { err(oa, 'an item must be an object {t, bucket, why}'); return null; }
        const bucket = str(o.bucket, oa, 'bucket', { max: 60 });
        if (bucket && !buckets.includes(bucket)) err(oa, `bucket ${JSON.stringify(bucket)} is not one of the buckets (${buckets.join(', ')})`);
        return { t: str(o.t, oa, 't (the item)', { max: LIMITS.opt }), bucket, why: why(o.why, oa) };
      }).filter(Boolean);
      for (const b of buckets) if (!out.items.some(i => i.bucket === b)) err(at, `no item belongs to the bucket ${JSON.stringify(b)}`);
    }
    return out;
  }

  // ---------------------------------------------------------------- items
  function quiz(it, at) {
    const out = { kind: 'quiz', id: slug(it.id, at, 'id'), title: str(it.title, at, 'title'), about: str(it.about, at, 'about', { max: LIMITS.text, required: false }), groups: [] };
    const seen = new Set(), gseen = new Set();
    arr(it.groups, at, 'groups', { min: 1, max: LIMITS.groups }).forEach((g, gi) => {
      const ga = `${at} › group ${gi + 1}`;
      if (!isObj(g)) { err(ga, 'a group must be an object {id, title, questions}'); return; }
      const grp = { id: slug(g.id, ga, 'id'), title: str(g.title, ga, 'title'), questions: [] };
      if (gseen.has(grp.id)) err(ga, `group id ${JSON.stringify(grp.id)} is used twice`); gseen.add(grp.id);
      arr(g.questions, ga, 'questions', { min: 1, max: LIMITS.questions }).forEach((q, qi) => {
        const qa = `${ga} › question ${qi + 1}`;
        const nq = question(q, qa);
        if (!nq) return;
        if (nq.id && seen.has(nq.id)) err(qa, `question id ${JSON.stringify(nq.id)} is used twice in this quiz`);
        seen.add(nq.id);
        grp.questions.push(nq);
      });
      out.groups.push(grp);
    });
    return out;
  }
  function exam(it, at) {
    const out = { kind: 'exam', id: slug(it.id, at, 'id'), title: str(it.title, at, 'title'), about: str(it.about, at, 'about', { max: LIMITS.text, required: false }), questions: [] };
    const qs = arr(it.questions, at, 'questions', { min: 10, max: 10 });
    const seen = new Set();
    qs.forEach((q, qi) => {
      const qa = `${at} › question ${qi + 1}`;
      const nq = question(q, qa);
      if (!nq) return;
      if (nq.type !== 'single') err(qa, 'exam questions must all be single-choice (type "single")');
      if (nq.id && seen.has(nq.id)) err(qa, `question id ${JSON.stringify(nq.id)} is used twice in this exam`);
      seen.add(nq.id);
      out.questions.push(nq);
    });
    return out;
  }

  // ---------------------------------------------------------------- the pack
  if (!isObj(raw)) { err('file', 'the file must contain one JSON object'); return { ok: false, errors, warnings, pack: null }; }
  if (raw.format !== 'bash-stash-pack') err('file', `"format" must be "bash-stash-pack", got ${JSON.stringify(raw.format)}`);
  if (raw.version !== 1) err('file', `"version" must be 1, got ${JSON.stringify(raw.version)}`);
  const pack = { format: 'bash-stash-pack', version: 1, id: slug(raw.id, 'file', 'id'), title: str(raw.title, 'file', 'title'),
    description: str(raw.description, 'file', 'description', { max: LIMITS.text, required: false }), items: [] };
  const ids = new Set();
  arr(raw.items, 'file', 'items', { min: 1, max: LIMITS.items }).forEach((it, i) => {
    const at = `item ${i + 1}`;
    if (!isObj(it)) { err(at, 'an item must be an object with a "kind"'); return; }
    if (!KINDS.includes(it.kind)) {
      err(at, ['exercise', 'script', 'scriptexam'].includes(it.kind) ? `kind ${JSON.stringify(it.kind)} cannot be imported yet (this version imports ${KINDS.join(' and ')})` : `kind must be one of ${KINDS.join(', ')}, got ${JSON.stringify(it.kind)}`);
      return;
    }
    const n = it.kind === 'quiz' ? quiz(it, at) : exam(it, at);
    if (n.id && ids.has(it.kind + ':' + n.id)) err(at, `${it.kind} id ${JSON.stringify(n.id)} is used twice in this pack`);
    ids.add(it.kind + ':' + n.id);
    pack.items.push(n);
  });
  return { ok: errors.length === 0, errors, warnings, pack: errors.length ? null : pack };
}

// what the page lists for a pack
function summarize(pack) {
  return { id: pack.id, title: pack.title, description: pack.description || '', addedAt: pack.addedAt || null,
    items: pack.items.map(it => ({ kind: it.kind, id: it.id, title: it.title,
      count: it.kind === 'quiz' ? it.groups.reduce((n, g) => n + g.questions.length, 0) : it.questions.length })) };
}

module.exports = { validatePack, summarize, SLUG, LIMITS };
