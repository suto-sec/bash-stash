// bash stash — importing content packs. A pack is ONE json file:
//   { "format": "bash-stash-pack", "version": 1, "id": "my-pack", "title": "...", "description": "...", "items": [ ... ] }
// Items: { "kind": "quiz" } and { "kind": "exam" } are data only. { "kind": "script" } and { "kind": "scriptexam" } carry code (a fixture, a checker and a reference
// solution per step): it is read by web/scanner.js here (red findings refuse the import, the others are warnings) and it is never run until
// the user has looked at it and allowed the pack (web/server.js).
// validatePack() checks a parsed pack and returns the normalized copy (only known fields, trimmed strings) together with every
// problem found, each with the place where it is, so the page can show "item 2 > group 1 > question 3: the right option is missing".
// The format is described for humans (and for LLMs) in web/import-prompt.md; keep the two in step.
'use strict';

const SLUG = /^[a-z0-9][a-z0-9-]{0,39}$/;
const KINDS = ['quiz', 'exam', 'script', 'scriptexam'];
const TAGS = ['arguments', 'exit codes', 'tests', 'loops', 'case', 'arithmetic', 'files', 'text', 'find', 'copy and move', 'permissions', 'archives', 'logs', 'pipes'];   // as tools/build_scripts.js
const { scan } = require('./scanner');
const { spawnSync } = require('child_process');
const CODE_MAX = 20000;
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
    if (v.length < min) err(at, `${what} needs at least ${min} ${min === 1 ? 'entry' : 'entries'}, it has ${v.length}`);
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

  // ---------------------------------------------------------------- scripts (code!)
  const syntax = (code, at, what) => {
    const r = spawnSync('bash', ['-n'], { input: code, encoding: 'utf8', timeout: 5000 });
    if (r.status !== 0 && r.stderr) err(at, `${what} is not valid bash: ${r.stderr.replace(/^bash: (line )?/, '').split('\n')[0].replace(/^\d+: /, m => 'line ' + m)}`);
  };
  const findings = (code, at, what) => {
    for (const f of scan(code)) {
      const msg = `${what}, line ${f.line}: ${f.msg}${f.snippet ? ` — ${JSON.stringify(f.snippet)}` : ''}`;
      if (f.level === 'red') err(at, msg); else warn(at, msg);
    }
  };
  function script(it, at) {
    const out = { kind: 'script', id: slug(it.id, at, 'id'), title: str(it.title, at, 'title'), script: '', level: 0, tags: [], cmds: str(it.cmds, at, 'cmds', { max: 300, required: false }), fixture: '', steps: [] };
    if (typeof it.script !== 'string' || !/^[a-z][a-z0-9_-]{0,30}\.sh$/.test(it.script)) err(at, `"script" must be the file name of the script, lowercase, ending in .sh (for example "backup.sh"), got ${JSON.stringify(it.script)}`); else out.script = it.script;
    if (!Number.isInteger(it.level) || it.level < 1 || it.level > 5) err(at, `"level" must be a whole number from 1 to 5 (the stars), got ${JSON.stringify(it.level)}`); else out.level = it.level;
    out.tags = arr(it.tags, at, 'tags', { min: 1, max: 3 }).map(t => { if (!TAGS.includes(t)) err(at, `tag ${JSON.stringify(t)} is not one of: ${TAGS.join(', ')}`); return t; }).filter(t => TAGS.includes(t));
    if (it.fixture !== undefined && it.fixture !== '') {
      if (typeof it.fixture !== 'string') err(at, '"fixture" must be text (bash code)');
      else if (it.fixture.length > CODE_MAX) err(at, `"fixture" is too long (${it.fixture.length} characters, at most ${CODE_MAX})`);
      else { out.fixture = it.fixture.replace(/\r\n?/g, '\n'); syntax(out.fixture, at, 'the fixture'); findings(out.fixture, at, 'fixture'); }
    }
    arr(it.steps, at, 'steps', { min: 1, max: 8 }).forEach((s, i) => {
      const sa = `${at} › step ${i + 1}`;
      if (!isObj(s)) { err(sa, 'a step must be an object {title, readme, check, solution}'); return; }
      const st = { n: i + 1, title: str(s.title, sa, 'title'), readme: str(s.readme, sa, 'readme (the statement)', { max: 6000 }), check: '', solution: '' };
      for (const k of ['check', 'solution']) {
        const v = s[k];
        if (typeof v !== 'string' || !v.trim()) { err(sa, `"${k}" is missing`); continue; }
        if (v.length > CODE_MAX) { err(sa, `"${k}" is too long (${v.length} characters, at most ${CODE_MAX})`); continue; }
        st[k] = v.replace(/\r\n?/g, '\n');
      }
      if (st.check) {
        if (!/^\s*ARGS=\(/m.test(st.check)) err(sa, 'the checker must define the test cases: ARGS=( \'case one\' \'case two\' ... )');
        syntax(`${out.fixture}\n${st.check}`, sa, 'the checker (with the fixture)');
        findings(st.check, sa, 'checker');
      }
      if (st.solution) { syntax(st.solution, sa, 'the solution'); findings(st.solution, sa, 'solution'); }
      out.steps.push(st);
    });
    return out;
  }

  function scriptexam(it, at) {
    const out = { kind: 'scriptexam', id: slug(it.id, at, 'id'), title: str(it.title, at, 'title'), script: '', cmds: str(it.cmds, at, 'cmds', { max: 300, required: false }),
      statement: str(it.statement, at, 'statement (the text of the exam)', { max: 8000 }), objectives: [], fixture: '', check: '', solution: '' };
    if (typeof it.script !== 'string' || !/^[a-z][a-z0-9_-]{0,30}\.sh$/.test(it.script)) err(at, `"script" must be the file name of the script, lowercase, ending in .sh, got ${JSON.stringify(it.script)}`); else out.script = it.script;
    const seen = new Set();
    arr(it.objectives, at, 'objectives', { min: 2, max: 6 }).forEach((o, i) => {
      const oa = `${at} › objective ${i + 1}`;
      if (!isObj(o)) { err(oa, 'an objective must be an object {id, label, points}'); return; }
      const id = typeof o.id === 'string' && /^[a-z][a-z0-9]{0,14}$/.test(o.id) ? o.id : (err(oa, `"id" must be a short lowercase word (letters and digits, e.g. "args"), got ${JSON.stringify(o.id)}`), '');
      if (id && seen.has(id)) err(oa, `objective id ${JSON.stringify(id)} is used twice`);
      seen.add(id);
      const points = Number.isInteger(o.points) && o.points >= 1 && o.points <= 10 ? o.points : (err(oa, `"points" must be a whole number from 1 to 10, got ${JSON.stringify(o.points)}`), 0);
      out.objectives.push({ id, label: str(o.label, oa, 'label', { max: 120 }).replace(/\|/g, '/'), points });
    });
    const sum = out.objectives.reduce((n, o) => n + o.points, 0);
    if (out.objectives.length && sum !== 10) err(at, `the objectives' points must add up to 10, they add up to ${sum}`);
    for (const k of ['fixture', 'check', 'solution']) {
      const v = it[k];
      if (k === 'fixture' && (v === undefined || v === '')) continue;
      if (typeof v !== 'string' || !v.trim()) { err(at, `"${k}" is missing`); continue; }
      if (v.length > CODE_MAX) { err(at, `"${k}" is too long (${v.length} characters, at most ${CODE_MAX})`); continue; }
      out[k] = v.replace(/\r\n?/g, '\n');
    }
    if (out.check) {
      if (!/^\s*ARGS=\(/m.test(out.check)) err(at, 'the checker must define the test cases: ARGS=( ... )');
      if (!/^\s*CASE_OBJ=\(/m.test(out.check)) err(at, 'the checker must say which objective each case belongs to: CASE_OBJ=( objective-id ... ) (same order and length as ARGS)');
      else for (const o of out.objectives) if (o.id && !new RegExp(`\\b${o.id}\\b`).test(out.check.match(/^\s*CASE_OBJ=\([^)]*\)/m)?.[0] || '')) warn(at, `no test case belongs to the objective "${o.id}": it can never earn its points`);
    }
    for (const [k, v] of [['fixture', out.fixture], ['check', out.check]]) if (/^\s*(OBJECTIVES|SCRIPT_NAME)=/m.test(v)) err(at, `"${k}" must not define OBJECTIVES or SCRIPT_NAME: they are built from "objectives" and "script"`);
    if (out.check || out.fixture) { syntax(`${out.fixture}\n${out.check}`, at, 'the checker (with the fixture)'); }
    if (out.fixture) findings(out.fixture, at, 'fixture');
    if (out.check) findings(out.check, at, 'checker');
    if (out.solution) { syntax(out.solution, at, 'the solution'); findings(out.solution, at, 'solution'); }
    return out;
  }

  // ---------------------------------------------------------------- the pack
  if (!isObj(raw)) { err('file', 'the file must contain one JSON object'); return { ok: false, errors, warnings, pack: null }; }
  if (raw.format !== 'bash-stash-pack') err('file', `"format" must be "bash-stash-pack", got ${JSON.stringify(raw.format)}`);
  if (raw.version !== 1) err('file', `"version" must be 1, got ${JSON.stringify(raw.version)}`);
  if (raw.id === 'history' || raw.id === 'validate') err('file', `the id ${JSON.stringify(raw.id)} is reserved, choose another`);
  const pack = { format: 'bash-stash-pack', version: 1, id: slug(raw.id, 'file', 'id'), title: str(raw.title, 'file', 'title'),
    description: str(raw.description, 'file', 'description', { max: LIMITS.text, required: false }), items: [] };
  const ids = new Set();
  arr(raw.items, 'file', 'items', { min: 1, max: LIMITS.items }).forEach((it, i) => {
    const at = `item ${i + 1}`;
    if (!isObj(it)) { err(at, 'an item must be an object with a "kind"'); return; }
    if (!KINDS.includes(it.kind)) {
      err(at, it.kind === 'exercise' ? `kind "exercise" does not exist: a plain exercise is a "script" with one step; kinds: ${KINDS.join(', ')}` : `kind must be one of ${KINDS.join(', ')}, got ${JSON.stringify(it.kind)}`);
      return;
    }
    const n = it.kind === 'quiz' ? quiz(it, at) : it.kind === 'exam' ? exam(it, at) : it.kind === 'script' ? script(it, at) : scriptexam(it, at);
    const key = (it.kind === 'script' || it.kind === 'scriptexam' ? 'code' : it.kind) + ':' + n.id;       // (a script and a script exam share the folder names)
    if (n.id && ids.has(key)) err(at, `${it.kind === 'script' || it.kind === 'scriptexam' ? 'script / script exam' : it.kind} id ${JSON.stringify(n.id)} is used twice in this pack`);
    ids.add(key);
    pack.items.push(n);
  });
  return { ok: errors.length === 0, errors, warnings, pack: errors.length ? null : pack };
}

// what the page lists for a pack
function summarize(pack) {
  return { id: pack.id, title: pack.title, description: pack.description || '', addedAt: pack.addedAt || null,
    items: pack.items.map(it => ({ kind: it.kind, id: it.id, title: it.title,
      count: it.kind === 'quiz' ? it.groups.reduce((n, g) => n + g.questions.length, 0) : it.kind === 'exam' ? it.questions.length : it.kind === 'script' ? it.steps.length : it.objectives.length })),
    code: pack.items.some(i => i.kind === 'script' || i.kind === 'scriptexam') };
}

module.exports = { validatePack, summarize, SLUG, LIMITS, TAGS };
