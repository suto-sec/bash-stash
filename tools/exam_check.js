#!/usr/bin/env node
// Near-duplicate check for practice-exam questions (English sources). Compares every question of the given sets with
//   - the theory quizzes already in the app (theory/*.json),
//   - the other practice exams (theory/exams/*.json),
//   - the reference exams used only to calibrate difficulty (EXAMS_REF=<dir with the cleaned reference exam .txt files>;
//     unset: skipped), whose scenarios must NOT be reused. They are kept outside the repository.
// Run `node tools/build_theory.js <files>` first (it writes theory/exams/<id>.json). Exit code 1 when a question is too close.
//   usage: node tools/exam_check.js [tools/theory/exams/easy-01.txt ...]      (default: every exam)
'use strict';
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const REF = process.env.EXAMS_REF || '';
const STOP = new Set('a an the of to in on is are be it its this that these those and or for with as at by from which what when how does do did can will would should may if then than not no into your you one only also any each'.split(' '));
const toks = s => new Set(String(s).toLowerCase().split(/\s+/)
  .map(t => t.replace(/^[`"'(\[{]+|[`"'.,;:)\]}?!]+$/g, '')).filter(t => t && !STOP.has(t)));
const jac = (a, b) => { if (!a.size || !b.size) return 0; let n = 0; for (const x of a) if (b.has(x)) n++; return n / (a.size + b.size - n); };
const mk = (id, stem, opts) => ({ id, stem: toks(stem), all: toks(stem + ' ' + opts.join(' ')), raw: stem });
// a stem of only a few words says little: compare it on its own only when both have at least this many words
const MIN_STEM = 6;

function fromJson(file, tag) {
  let c;
  try { c = JSON.parse(fs.readFileSync(file, 'utf8')); } catch { return []; }   // a file another author is writing right now
  const qs = c.questions || (c.groups || []).flatMap(g => g.questions);
  return qs.map(q => mk(`${tag}${c.id}/${q.id}`, q.text, [...(q.options || []).map(o => o.t), ...(q.items || []).map(i => i.t), ...(q.pairs || []).map(p => p.l + ' ' + p.r)]));
}
function fromRef(file) {   // "Sxx | stem" followed by "+ / +~ / - option" lines
  const out = []; let cur = null;
  for (const line of fs.readFileSync(file, 'utf8').split('\n')) {
    let m;
    if ((m = line.match(/^([A-Z]\d\d) \| (.*)$/))) { if (cur) out.push(cur); cur = { id: `ref:${path.basename(file, '.txt')}/${m[1]}`, stem: m[2], opts: [] }; }
    else if (cur && (m = line.match(/^(\+~?|-) (.*)$/))) cur.opts.push(m[2]);
  }
  if (cur) out.push(cur);
  return out.map(q => mk(q.id, q.stem, q.opts));
}
const ls = (dir, ext) => { try { return fs.readdirSync(dir).filter(f => f.endsWith(ext)).sort().map(f => path.join(dir, f)); } catch { return []; } };

const targets = process.argv.length > 2 ? process.argv.slice(2).map(f => path.basename(f, '.txt'))
  : ls(path.join(ROOT, 'tools/theory/exams'), '.txt').map(f => path.basename(f, '.txt'));
const corpus = { quiz: [], exam: [], ref: [] };
for (const f of ls(path.join(ROOT, 'theory'), '.json')) corpus.quiz.push(...fromJson(f, 'quiz:'));
for (const f of ls(path.join(ROOT, 'theory/exams'), '.json')) if (!targets.includes(path.basename(f, '.json'))) corpus.exam.push(...fromJson(f, 'exam:'));
if (REF && fs.existsSync(REF)) for (const f of ls(REF, '.txt')) corpus.ref.push(...fromRef(f));
else console.warn('note: EXAMS_REF is not set (or not a directory): not comparing with the reference exams');
// [error stem, error all, warn stem]: the reference exams are the strictest, they must not be echoed at all
const LIMIT = { ref: [0.45, 0.4, 0.35], quiz: [0.65, 0.6, 0.5], exam: [0.6, 0.55, 0.5] };

let bad = 0, warn = 0;
const own = [];
for (const id of targets) {
  const file = path.join(ROOT, 'theory/exams', id + '.json');
  if (!fs.existsSync(file)) { console.error(`${id}: not built (node tools/build_theory.js tools/theory/exams/${id}.txt)`); bad++; continue; }
  own.push(...fromJson(file, 'self:'));
}
// questions within the targets are compared with each other too (same limits as other exams)
const pool = { ...corpus, exam: [...corpus.exam] };
own.forEach((q, i) => {
  for (const kind of ['ref', 'quiz', 'exam']) {
    const [es, ea, ws] = LIMIT[kind];
    const others = kind === 'exam' ? [...pool.exam, ...own.slice(0, i)] : pool[kind];
    let best = null;
    for (const o of others) {
      const s = q.stem.size >= MIN_STEM && o.stem.size >= MIN_STEM ? jac(q.stem, o.stem) : 0, a = jac(q.all, o.all);
      if (!best || Math.max(s, a) > Math.max(best.s, best.a)) best = { o, s, a };
    }
    if (!best) continue;
    const tag = `${q.id.replace('self:', '')}`;
    if (best.s >= es || best.a >= ea) { bad++; console.log(`ERROR ${tag}: too close to ${best.o.id} (stem ${best.s.toFixed(2)}, with options ${best.a.toFixed(2)})`); }
    else if (best.s >= ws) { warn++; console.log(`warn  ${tag}: similar to ${best.o.id} (stem ${best.s.toFixed(2)}, with options ${best.a.toFixed(2)})`); }
  }
});
console.log(`checked ${own.length} questions against ${corpus.quiz.length} quiz, ${corpus.exam.length} exam and ${corpus.ref.length} reference questions: ${bad} too close, ${warn} warnings`);
process.exit(bad ? 1 : 0);
