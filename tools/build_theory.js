#!/usr/bin/env node
// Compiles tools/theory/*.txt (quiz sources) into theory/<collection>.json and validates them.
// usage: node tools/build_theory.js [file.txt ...]      (no args: every file in tools/theory/ and tools/theory/es/)
//
// Translations: tools/theory/<lang>/<same file>.txt, same format, same collection id. A translation
// must mirror its English file question by question (same groups, types, option counts, which
// options are right, buckets, number of blanks); ids are copied from the English file, so the
// learner's progress is shared across languages. Output: theory/<lang>/<id>.json.
//
// Source format (one file per collection, see tools/THEORY_AUTHORING.md):
//   @@collection <id> | <title>          first line of the file
//   @@about                              (optional) description shown on the home page, until next @@
//   @@group <title>                      starts a group of questions (sidebar sub-category)
//   @@q <type> | <short title>           type: single | multi | fill | order | match | sort
//   <question text, markdown>            until the first option line or @@ line
//   (+) right option :: why it is right  single/multi   (-) wrong option :: why it is wrong
//   (>) step :: why it goes here         order: steps listed in the CORRECT order
//   (=) left => right :: why             match: pairs ; (-) distractor :: why it matches nothing
//   @@buckets A | B | C                  sort: the categories ; (A) item :: why it belongs to A (names may contain parentheses)
//   {{answer ;; alt}} in the text        fill: a blank with its accepted answers
//   (x) wrong answer :: why not          fill: tempting wrong answers and why they fail
//   @@note                               optional closing takeaway (markdown, until next @@)
//
// Practice exams (tools/theory/exams/<id>.txt, translations in exams/es/): one set per file, built into
// theory/exams/<id>.json (and theory/exams/es/<id>.json). Same question syntax, with these differences:
//   @@exam <tier>-NN | <title>           first line; the id must be easy-NN, medium-NN or hard-NN and equal the file name
//   @@tier easy|medium|hard              required in the English file (copied into translations)
//   no @@group; exactly 10 questions, each `single` with exactly 4 options and one (+)
//   @@topic <topic>                      required in every English question (see EXAM_TOPICS below)
//   (+!) / (-!)                          an option that is always shown last (e.g. "None of the above"); at most one, written last
// usage: node tools/build_theory.js exams                      every exam file (and nothing else)
//        node tools/build_theory.js tools/theory/exams/easy-01.txt [...]   only these (an exams/es file also parses its English one)
//        node tools/build_theory.js                             collections and exams
'use strict';
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const SRC = path.join(ROOT, 'tools/theory');
const OUT = path.join(ROOT, 'theory');
const LANGS = ['es'];
const TYPES = ['single', 'multi', 'fill', 'order', 'match', 'sort'];
const EXAM_SRC = path.join(SRC, 'exams');
const EXAM_OUT = path.join(OUT, 'exams');
const EXAM_TIERS = ['easy', 'medium', 'hard'];
const EXAM_SIZE = 10;
// every exam question names the T1 topic it belongs to: this is what lets us check coverage across all sets
const EXAM_TOPICS = ['shell-help', 'jobs-procs', 'files-fs', 'permissions', 'filters', 'grep-regex', 'find',
  'expansion-vars', 'redirection-pipes', 'scripts', 'users-sessions', 'boot-systemd', 'logs-cron'];
const errors = [];
let curFile = '', curLine = 0;
const err = msg => errors.push(`${curFile}:${curLine}: ${msg}`);
const slug = s => s.toLowerCase().replace(/[`'"]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 60);

function splitWhy(s) {
  const i = s.indexOf(' :: ');
  return i < 0 ? [s.trim(), ''] : [s.slice(0, i).trim(), s.slice(i + 4).trim()];
}

function finishQuestion(q, col) {
  if (!q) return;
  curLine = q.line;
  const t = q.type;
  if (t === 'fill') {  // {{a ;; b}} becomes {{0}}, {{1}}... and the answers are stored aside
    q.text = q.text.replace(/\{\{([\s\S]*?)\}\}(?!\})/g, (_, a) => {
      q.blanks.push({ answers: a.split(';;').map(s => s.trim()) });
      return `{{${q.blanks.length - 1}}}`;
    });
  }
  const need = (cond, msg) => { if (!cond) err(`"${q.title}": ${msg}`); };
  need(q.text.trim(), 'empty question text');
  const exam = col.kind === 'exam';
  if (t === 'single' || t === 'multi') {
    const ok = q.options.filter(o => o.ok).length, bad = q.options.length - ok;
    need(t === 'single' ? ok === 1 : ok >= 2, t === 'single' ? 'needs exactly one (+) option' : 'needs at least two (+) options');
    need(bad >= (t === 'single' ? 2 : 1), 'needs more (-) options');
    need(q.options.length >= 3 && q.options.length <= 7, 'use 3 to 7 options');
    for (const o of q.options) need(o.why, `option "${o.t}" has no explanation (:: ...)`);
    need(new Set(q.options.map(o => o.t)).size === q.options.length, 'duplicate option text');
    q.options.forEach(o => { if (!o.pin && /^(both|all|none|neither)\b.*(above|these)|\b[a-d]\)\s*(and|&)/i.test(o.t)) err(`"${q.title}": positional option "${o.t}" (options are shuffled; pin it with (+!) / (-!) to keep it last)`); });
    const pins = q.options.filter(o => o.pin);
    if (!exam) need(!pins.length, 'pinned options (+!) / (-!) are only for exam files');
    else {
      need(t === 'single', 'exam questions must be single choice');
      need(q.options.length === 4, `exam questions need exactly 4 options (has ${q.options.length})`);
      need(pins.length <= 1, 'at most one pinned option');
      need(!pins.length || q.options[q.options.length - 1].pin, 'the pinned option must be written last');
      if (!col.lang) need(EXAM_TOPICS.includes(q.topic), `needs "@@topic <one of: ${EXAM_TOPICS.join(', ')}>"`);
    }
  } else if (exam) {
    err(`"${q.title}": exam questions must be single choice`);
  } else if (t === 'fill') {
    need(q.blanks.length >= 1, 'needs at least one {{blank}}');
    q.blanks.forEach((b, i) => need(b.answers.length && b.answers.every(a => a), `blank ${i + 1} has an empty answer`));
    need(q.note, 'fill questions need a @@note explaining the answer');
    for (const w of q.wrong) need(w.why, `wrong answer "${w.a}" has no explanation`);
  } else if (t === 'order') {
    need(q.items.length >= 3 && q.items.length <= 8, 'use 3 to 8 steps');
    for (const it of q.items) need(it.why, `step "${it.t}" has no explanation`);
  } else if (t === 'match') {
    need(q.pairs.length >= 3 && q.pairs.length <= 8, 'use 3 to 8 pairs');
    for (const p of q.pairs) need(p.why, `pair "${p.l}" has no explanation`);
    for (const d of q.extras) need(d.why, `distractor "${d.r}" has no explanation`);
    const rs = [...q.pairs.map(p => p.r), ...q.extras.map(d => d.r)];
    need(new Set(rs).size === rs.length, 'duplicate right-hand side');
  } else if (t === 'sort') {
    need(q.buckets.length >= 2 && q.buckets.length <= 4, 'use 2 to 4 @@buckets');
    need(q.items.length >= 4 && q.items.length <= 10, 'use 4 to 10 items');
    for (const it of q.items) need(it.why, `item "${it.t}" has no explanation`);
    for (const b of q.buckets) need(q.items.some(it => it.bucket === b), `bucket "${b}" has no items`);
  }
  q.id = q.id || slug(q.title);
  if (col.ids.has(q.id) && !col.lang) err(`duplicate question id "${q.id}" (retitle it or give an explicit id)`);
  col.ids.add(q.id);
  const { line, ...clean } = q;
  col.cur.questions.push(clean);
}

function parse(file, lang) {
  curFile = (lang ? lang + '/' : '') + path.basename(file);
  const lines = fs.readFileSync(file, 'utf8').split('\n');
  const col = { id: '', title: '', about: '', groups: [], ids: new Set(), cur: null, lang, kind: 'collection', tier: '', ws: false };
  let q = null, section = null, lastItem = null;
  const addText = (obj, key, line) => { obj[key] = obj[key] ? obj[key] + '\n' + line : line; };
  for (let i = 0; i < lines.length; i++) {
    curLine = i + 1;
    const line = lines[i];
    let m;
    if (/^#/.test(line) && !q) continue; // comments between questions
    if ((m = line.match(/^@@collection\s+(\S+)\s*\|\s*(.+)$/))) { col.id = m[1]; col.title = m[2].trim(); section = null; continue; }
    if ((m = line.match(/^@@exam\s+(\S+)\s*\|\s*(.+)$/))) {   // an exam is one flat list: a single implicit group
      col.id = m[1]; col.title = m[2].trim(); col.kind = 'exam'; section = null;
      col.cur = { id: 'questions', title: 'Questions', questions: [] };
      col.groups.push(col.cur); continue;
    }
    if ((m = line.match(/^@@tier\s+(\w+)\s*$/))) { col.tier = m[1]; continue; }
    if (/^@@workspace\s*$/.test(line)) { col.ws = true; continue; }   // shown with the terminal / VS Code beside it (the man drills)
    if ((m = line.match(/^@@topic\s+(\S+)\s*$/)) && q) { q.topic = m[1]; continue; }
    if (/^@@about\s*$/.test(line)) { section = 'about'; continue; }
    if ((m = line.match(/^@@group\s+(.+)$/))) {
      if (col.kind === 'exam') { err('exam files have no @@group'); continue; }
      finishQuestion(q, col); q = null; section = null;
      col.cur = { id: slug(m[1]), title: m[1].trim(), questions: [] };
      col.groups.push(col.cur); continue;
    }
    if ((m = line.match(/^@@q\s+(\w+)\s*(?:\[([\w-]+)\])?\s*\|\s*(.+)$/))) {
      finishQuestion(q, col);
      if (!col.cur) { err('@@q before any @@group'); q = null; continue; }
      if (!TYPES.includes(m[1])) { err(`unknown question type "${m[1]}"`); q = null; continue; }
      q = { type: m[1], id: m[2] || '', title: m[3].trim(), text: '', note: '', line: curLine,
        options: [], blanks: [], wrong: [], items: [], pairs: [], extras: [], buckets: [] };
      section = 'text'; lastItem = null; continue;
    }
    if (/^@@note\s*$/.test(line)) { section = 'note'; lastItem = null; continue; }
    if ((m = line.match(/^@@buckets\s+(.+)$/)) && q) { q.buckets = m[1].split('|').map(s => s.trim()); continue; }
    if (/^@@/.test(line)) { err(`unknown directive: ${line}`); continue; }

    if (section === 'about') { addText(col, 'about', line); continue; }
    if (!q) { if (line.trim()) err('text outside a question'); continue; }

    // sort items: "(Bucket) item :: why", matched against the declared bucket names (they may contain parentheses)
    if (q.type === 'sort' && section !== 'note') {
      const b = q.buckets.find(x => line.startsWith('(' + x + ') '));
      if (b) {
        const [head, why] = splitWhy(line.slice(b.length + 3));
        section = 'items'; lastItem = { t: head, bucket: b, why }; q.items.push(lastItem); continue;
      }
    }
    // option lines
    if ((m = line.match(/^\(([+\->=x]|[^)\n]{1,40})\)\s+(.*)$/)) && section !== 'note' && (q.type === 'sort' || m[1].length === 1 || /^[+-]!$/.test(m[1]))) {
      const tag = m[1], body = m[2];
      section = 'items';
      const [head, why] = splitWhy(body);
      const t = q.type;
      if (t === 'single' || t === 'multi') {
        if (!/^[+-]!?$/.test(tag)) { err(`bad option tag "(${tag})"`); continue; }
        lastItem = { t: head, ok: tag[0] === '+', why };
        if (tag.endsWith('!')) lastItem.pin = true;
        q.options.push(lastItem);
      } else if (t === 'fill') {
        if (tag !== 'x') { err('fill questions only take (x) lines'); continue; }
        lastItem = { a: head, why }; q.wrong.push(lastItem);
      } else if (t === 'order') {
        if (tag !== '>') { err('order questions take (>) lines'); continue; }
        lastItem = { t: head, why }; q.items.push(lastItem);
      } else if (t === 'match') {
        if (tag === '=') {
          const k = head.indexOf(' => ');
          if (k < 0) { err('match pair needs "left => right"'); continue; }
          lastItem = { l: head.slice(0, k).trim(), r: head.slice(k + 4).trim(), why }; q.pairs.push(lastItem);
        } else if (tag === '-') { lastItem = { r: head, why }; q.extras.push(lastItem); }
        else { err(`bad match tag "(${tag})"`); continue; }
      } else if (t === 'sort') {
        lastItem = { t: head, bucket: tag, why };
        if (!q.buckets.includes(tag)) err(`unknown bucket "${tag}" (declare it with @@buckets)`);
        q.items.push(lastItem);
      }
      continue;
    }
    // continuation lines
    if (section === 'items' && lastItem && /^\s{2,}\S/.test(line)) {
      addText(lastItem, 'why', line.trim()); continue;
    }
    if (section === 'text') { addText(q, 'text', line); continue; }
    if (section === 'note') { addText(q, 'note', line); continue; }
    if (line.trim()) err(`unexpected line in ${section || 'question'}: ${line}`);
  }
  finishQuestion(q, col);
  curLine = 1;
  if (!col.id) err('missing @@collection line');
  for (const g of col.groups) for (const qu of g.questions) {
    qu.text = qu.text.replace(/^\n+|\n+$/g, '');
    qu.note = qu.note.replace(/^\n+|\n+$/g, '');
    for (const k of ['options', 'blanks', 'wrong', 'items', 'pairs', 'extras', 'buckets']) if (!qu[k].length) delete qu[k];
    if (!qu.note) delete qu.note;
  }
  return { id: col.id, title: col.title, about: col.about.trim(), kind: col.kind, tier: col.tier, ...(col.ws ? { ws: true } : {}), groups: col.groups };
}

// Soft lint (warning only): in a single-choice question the right option should not be conspicuously
// longer than every wrong one, or students can guess by length. Keep the distractors as detailed as the answer.
function lengthWarnings(c) {
  const out = [];
  for (const g of c.groups) for (const q of g.questions) {
    if (q.type !== 'single') continue;
    const ok = q.options.find(o => o.ok).t.length;
    const worst = Math.max(...q.options.filter(o => !o.ok).map(o => o.t.length));
    if (ok > 30 && ok > worst * 1.25) out.push(`${c.id}: "${q.title}": the right option is ${Math.round(100 * ok / worst - 100)}% longer than the longest wrong one`);
  }
  return out;
}

// A translation must have exactly the shape of the English collection; ids are taken from it.
function align(tr, en, file) {
  curFile = file; curLine = 1;
  const where = (g, k) => `group ${g + 1} ("${en.groups[g].title}"), question ${k + 1}`;
  tr.tier = en.tier;
  if (en.ws) tr.ws = true;
  if (tr.kind !== en.kind) return err(`${tr.kind} file for a ${en.kind}`);
  if (tr.groups.length !== en.groups.length) return err(`${tr.groups.length} groups, English has ${en.groups.length}`);
  tr.groups.forEach((g, gi) => {
    const eg = en.groups[gi];
    g.id = eg.id;
    if (g.questions.length !== eg.questions.length) return err(`group ${gi + 1} ("${eg.title}"): ${g.questions.length} questions, English has ${eg.questions.length}`);
    g.questions.forEach((q, k) => {
      const e = eg.questions[k], bad = msg => err(`${where(gi, k)} "${e.title}": ${msg}`);
      q.id = e.id;
      if (e.topic) q.topic = e.topic;
      if (q.type !== e.type) return bad(`type ${q.type}, English is ${e.type}`);
      const len = key => (q[key] || []).length === (e[key] || []).length || bad(`${key}: ${(q[key] || []).length} vs ${(e[key] || []).length} in English`);
      if (q.type === 'single' || q.type === 'multi') {
        if (len('options') === true && q.options.some((o, j) => o.ok !== e.options[j].ok)) bad('the right options are not in the same positions as in English');
        if (len('options') === true && q.options.some((o, j) => !!o.pin !== !!e.options[j].pin)) bad('the pinned option (+! / -!) is not in the same position as in English');
      } else if (q.type === 'fill') len('blanks');
      else if (q.type === 'order') len('items');
      else if (q.type === 'match') { len('pairs'); len('extras'); }
      else if (q.type === 'sort') {
        if (len('buckets') === true && len('items') === true &&
            q.items.some((it, j) => q.buckets.indexOf(it.bucket) !== e.buckets.indexOf(e.items[j].bucket))) bad('items are not in the same buckets as in English');
      }
    });
  });
}

const args = process.argv.slice(2);
const isUnder = (f, dir) => path.resolve(f).startsWith(dir + path.sep);
const examArgs = args.filter(a => isUnder(a, EXAM_SRC));
const collArgs = args.filter(a => a !== 'exams' && !isUnder(a, EXAM_SRC));
const wantColls = !args.length || collArgs.length > 0;
const wantExams = !args.length || args.includes('exams') || examArgs.length > 0;
const langOf = f => { const d = path.basename(path.dirname(path.resolve(f))); return LANGS.includes(d) ? d : null; };
const listTxt = dir => { try { return fs.readdirSync(dir).filter(f => f.endsWith('.txt')).sort().map(f => path.join(dir, f)); } catch { return []; } };
const out = [];

function report(c, prefix) {
  const n = c.groups.reduce((s, g) => s + g.questions.length, 0);
  const kinds = {};
  c.groups.forEach(g => g.questions.forEach(q => { kinds[q.type] = (kinds[q.type] || 0) + 1; }));
  console.log(`${prefix}${c.id}: ${n} questions in ${c.groups.length} groups  ${JSON.stringify(kinds)}`);
  for (const w of lengthWarnings(c)) console.warn('  warning: ' + w);
}

const collOut = c => ({ id: c.id, title: c.title, about: c.about, ...(c.ws ? { ws: true } : {}), groups: c.groups });   // same JSON shape as before exams existed
function buildCollections() {
  const wanted = collArgs.length ? new Set(collArgs.map(a => path.resolve(a))) : null;
  const english = {};
  for (const f of listTxt(SRC)) {   // English is always parsed: translations are checked against it
    const c = parse(f);
    english[c.id] = c;
    if (wanted && !wanted.has(path.resolve(f))) continue;
    out.push({ c: collOut(c), dir: OUT });
    report(c, '');
  }
  for (const f of LANGS.flatMap(l => listTxt(path.join(SRC, l)))) {
    if (wanted && !wanted.has(path.resolve(f))) continue;
    const lang = langOf(f), c = parse(f, lang);
    if (!english[c.id]) { curFile = lang + '/' + path.basename(f); curLine = 1; err(`no English collection "${c.id}"`); continue; }
    align(c, english[c.id], lang + '/' + path.basename(f));
    out.push({ c: collOut(c), dir: path.join(OUT, lang) });
    report(c, lang + '/');
  }
}

// Practice exams: only the files asked for are parsed (plus the English file behind a translation), so
// several people / agents can each build their own sets while others are half written.
function checkExam(c, file) {
  curFile = path.basename(file); curLine = 1;
  const base = path.basename(file, '.txt');
  if (c.kind !== 'exam') return err('first line must be "@@exam <id> | <title>"');
  if (!/^(easy|medium|hard)-\d\d$/.test(c.id)) err(`exam id "${c.id}" must look like easy-01, medium-12, hard-07`);
  if (c.id !== base) err(`exam id "${c.id}" must equal the file name "${base}"`);
  if (!EXAM_TIERS.includes(c.tier)) err(`@@tier must be one of ${EXAM_TIERS.join(', ')}`);
  else if (!c.id.startsWith(c.tier + '-')) err(`@@tier ${c.tier} does not match the id "${c.id}"`);
  const qs = c.groups[0] ? c.groups[0].questions : [];
  if (qs.length !== EXAM_SIZE) err(`an exam has exactly ${EXAM_SIZE} questions (has ${qs.length})`);
  if (BLUEPRINT) {
    const bp = BLUEPRINT[c.id];
    if (!bp) err(`"${c.id}" is not in blueprint.json (node tools/exam_blueprint.js)`);
    else qs.forEach((q, i) => { if (bp[i] && q.topic !== bp[i].topic) err(`question ${i + 1} must be about "${bp[i].topic}" (blueprint), not "${q.topic}"`); });
  }
  const perTopic = {};
  for (const q of qs) perTopic[q.topic] = (perTopic[q.topic] || 0) + 1;
  if (Object.keys(perTopic).length < 7) err(`questions should span at least 7 topics (spans ${Object.keys(perTopic).length})`);
  for (const [t, n] of Object.entries(perTopic)) if (n > 2) err(`topic "${t}" has ${n} questions; at most 2 per exam`);
  const stems = new Set();
  for (const q of qs) {
    const k = q.text.replace(/\s+/g, ' ').toLowerCase();
    if (stems.has(k)) err(`duplicate question text: "${q.title}"`);
    stems.add(k);
  }
}
// tools/theory/exams/blueprint.json (tools/exam_blueprint.js) assigns every question slot of every set a topic
let BLUEPRINT = null;
try { BLUEPRINT = JSON.parse(fs.readFileSync(path.join(EXAM_SRC, 'blueprint.json'), 'utf8')).sets; } catch { /* no blueprint: only the generic rules apply */ }
const examOut = c => ({ id: c.id, title: c.title, about: c.about, tier: c.tier, questions: c.groups[0].questions });

function buildExams() {
  const wanted = examArgs.length && !args.includes('exams') ? new Set(examArgs.map(a => path.resolve(a))) : null;
  for (const w of wanted || []) if (!fs.existsSync(w)) { curFile = path.relative(ROOT, w); curLine = 1; err('no such file'); }
  const parsed = new Map();   // English exams, parsed once
  const parseEn = f => {
    f = path.resolve(f);
    if (!parsed.has(f)) { const c = parse(f); checkExam(c, f); parsed.set(f, c); }
    return parsed.get(f);
  };
  for (const f of listTxt(EXAM_SRC)) {
    if (wanted && !wanted.has(path.resolve(f))) continue;
    const c = parseEn(f);
    out.push({ c: examOut(c), dir: EXAM_OUT });
    report(c, '');
  }
  for (const f of LANGS.flatMap(l => listTxt(path.join(EXAM_SRC, l)))) {
    if (wanted && !wanted.has(path.resolve(f))) continue;
    const lang = langOf(f), name = lang + '/' + path.basename(f), enFile = path.join(EXAM_SRC, path.basename(f));
    if (!fs.existsSync(enFile)) { curFile = name; curLine = 1; err('no English exam file with this name'); continue; }
    const en = parseEn(enFile), c = parse(f, lang);
    curFile = name; curLine = 1;
    if (c.id !== en.id) err(`exam id "${c.id}" must equal the English one "${en.id}"`);
    align(c, en, name);
    out.push({ c: examOut(c), dir: path.join(EXAM_OUT, lang) });
    report(c, lang + '/');
  }
  if (!wanted) coverage(parsed);
}

// Full exam build: how many questions each topic has per tier (the blueprint check), and cross-set duplicates.
function coverage(parsed) {
  const grid = {}, stems = new Map();
  for (const [file, c] of parsed) {
    for (const q of c.groups[0] ? c.groups[0].questions : []) {
      (grid[q.topic] = grid[q.topic] || {})[c.tier] = ((grid[q.topic] || {})[c.tier] || 0) + 1;
      const k = q.text.replace(/\s+/g, ' ').toLowerCase();
      if (stems.has(k)) { curFile = path.basename(file); curLine = 1; err(`question text also used in ${stems.get(k)}: "${q.title}"`); }
      else stems.set(k, path.basename(file));
    }
  }
  if (!parsed.size) return;
  console.log('\nexam coverage (questions per topic and tier):');
  for (const t of EXAM_TOPICS) {
    const g = grid[t] || {};
    console.log(`  ${t.padEnd(18)}${EXAM_TIERS.map(x => `${x} ${String(g[x] || 0).padStart(3)}`).join('   ')}`);
  }
}

if (wantColls) buildCollections();
if (wantExams) buildExams();
if (errors.length) { console.error('\n' + errors.join('\n')); console.error(`\n${errors.length} problem(s), nothing written`); process.exit(1); }
for (const { c, dir } of out) {
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, `${c.id}.json`), JSON.stringify(c) + '\n');
}
