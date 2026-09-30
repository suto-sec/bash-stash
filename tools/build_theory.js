#!/usr/bin/env node
// Compiles tools/theory/*.txt (quiz sources) into theory/<collection>.json and validates them.
// usage: node tools/build_theory.js [file.txt ...]      (no args: every file in tools/theory/)
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
'use strict';
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const SRC = path.join(ROOT, 'tools/theory');
const OUT = path.join(ROOT, 'theory');
const TYPES = ['single', 'multi', 'fill', 'order', 'match', 'sort'];
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
  if (t === 'single' || t === 'multi') {
    const ok = q.options.filter(o => o.ok).length, bad = q.options.length - ok;
    need(t === 'single' ? ok === 1 : ok >= 2, t === 'single' ? 'needs exactly one (+) option' : 'needs at least two (+) options');
    need(bad >= (t === 'single' ? 2 : 1), 'needs more (-) options');
    need(q.options.length >= 3 && q.options.length <= 7, 'use 3 to 7 options');
    for (const o of q.options) need(o.why, `option "${o.t}" has no explanation (:: ...)`);
    need(new Set(q.options.map(o => o.t)).size === q.options.length, 'duplicate option text');
    q.options.forEach(o => { if (/^(both|all|none|neither)\b.*(above|these)|\b[a-d]\)\s*(and|&)/i.test(o.t)) err(`"${q.title}": positional option "${o.t}" (options are shuffled)`); });
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
  if (col.ids.has(q.id)) err(`duplicate question id "${q.id}" (retitle it or give an explicit id)`);
  col.ids.add(q.id);
  const { line, ...clean } = q;
  col.cur.questions.push(clean);
}

function parse(file) {
  curFile = path.basename(file);
  const lines = fs.readFileSync(file, 'utf8').split('\n');
  const col = { id: '', title: '', about: '', groups: [], ids: new Set(), cur: null };
  let q = null, section = null, lastItem = null;
  const addText = (obj, key, line) => { obj[key] = obj[key] ? obj[key] + '\n' + line : line; };
  for (let i = 0; i < lines.length; i++) {
    curLine = i + 1;
    const line = lines[i];
    let m;
    if (/^#/.test(line) && !q) continue; // comments between questions
    if ((m = line.match(/^@@collection\s+(\S+)\s*\|\s*(.+)$/))) { col.id = m[1]; col.title = m[2].trim(); section = null; continue; }
    if (/^@@about\s*$/.test(line)) { section = 'about'; continue; }
    if ((m = line.match(/^@@group\s+(.+)$/))) {
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
    if ((m = line.match(/^\(([+\->=x]|[^)\n]{1,40})\)\s+(.*)$/)) && section !== 'note' && (q.type === 'sort' || m[1].length === 1)) {
      const tag = m[1], body = m[2];
      section = 'items';
      const [head, why] = splitWhy(body);
      const t = q.type;
      if (t === 'single' || t === 'multi') {
        if (tag !== '+' && tag !== '-') { err(`bad option tag "(${tag})"`); continue; }
        lastItem = { t: head, ok: tag === '+', why };
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
  return { id: col.id, title: col.title, about: col.about.trim(), groups: col.groups };
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

const files = process.argv.length > 2 ? process.argv.slice(2)
  : fs.readdirSync(SRC).filter(f => f.endsWith('.txt')).sort().map(f => path.join(SRC, f));
fs.mkdirSync(OUT, { recursive: true });
const out = [];
for (const f of files) {
  const c = parse(f);
  out.push(c);
  if (!errors.length) fs.writeFileSync(path.join(OUT, `${c.id}.json`), JSON.stringify(c) + '\n');
  const n = c.groups.reduce((s, g) => s + g.questions.length, 0);
  const kinds = {};
  c.groups.forEach(g => g.questions.forEach(q => { kinds[q.type] = (kinds[q.type] || 0) + 1; }));
  console.log(`${c.id}: ${n} questions in ${c.groups.length} groups  ${JSON.stringify(kinds)}`);
  for (const w of lengthWarnings(c)) console.warn('  warning: ' + w);
}
if (errors.length) { console.error('\n' + errors.join('\n')); console.error(`\n${errors.length} problem(s), nothing written`); process.exit(1); }
