#!/usr/bin/env node
// Builds the script practice exams (one bash script each, graded by objectives out of 10) from
// tools/src/script-exams/<tier>-NN.txt into:
//   script-exams/<id>_<slug>/README.md, README.es.md, check.sh, meta.json
//   solutions/script-exams/<id>_<slug>.sh            (the reference solution the checker compares against)
// Source format (see tools/EXAMS_AUTHORING.md, "Script exams"):
//   @@sexam easy-01 | slug | English title | Título en español
//   @@script name.sh
//   @@cmds find, cp, ...
//   @@objectives                one line each:  id | English label | Etiqueta en español | points   (points add up to 10)
//   @@readme en  /  @@readme es  the statement (markdown)
//   @@check                     checker spec for lib/engine.sh; also defines CASE_OBJ=( ... ), one objective id per ARGS entry
//   @@solution                  the reference solution
// usage: node tools/build_script_exams.js [source files...]
'use strict';
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const SRC = path.join(__dirname, 'src/script-exams');
const OUT = path.join(ROOT, 'script-exams');
const SOL = path.join(ROOT, 'solutions/script-exams');
const TOTAL = 10;

function parse(file) {
  const lines = fs.readFileSync(file, 'utf8').split('\n');
  const o = { objectives: [], readme: {}, check: [], solution: [], cmds: '' };
  let sec = null, lang = null;
  const err = (n, m) => { throw new Error(`${path.basename(file)}:${n + 1}: ${m}`); };
  lines.forEach((l, n) => {
    let m;
    if ((m = l.match(/^@@sexam\s+(\S+)\s*\|\s*([\w-]+)\s*\|\s*(.+?)\s*\|\s*(.+?)\s*$/))) {
      o.id = m[1]; o.slug = m[2]; o.title = { en: m[3], es: m[4] }; sec = null; return;
    }
    if ((m = l.match(/^@@script\s+(\S+)\s*$/))) { o.script = m[1]; return; }
    if ((m = l.match(/^@@cmds\s+(.*)$/))) { o.cmds = m[1].trim(); return; }
    if ((m = l.match(/^@@(objectives|check|solution)\s*$/))) { sec = m[1]; return; }
    if ((m = l.match(/^@@readme\s+(en|es)\s*$/))) { sec = 'readme'; lang = m[1]; o.readme[lang] = []; return; }
    if (/^@@/.test(l)) err(n, `unknown directive "${l.split(' ')[0]}"`);
    if (sec === 'objectives') {
      if (!l.trim()) return;
      const p = l.split('|').map(s => s.trim());
      if (p.length !== 4 || !/^[a-z][a-z0-9]*$/.test(p[0]) || !/^\d+$/.test(p[3])) err(n, 'objective line: id | English label | etiqueta en español | points');
      o.objectives.push({ id: p[0], label: { en: p[1], es: p[2] }, points: +p[3] });
    } else if (sec === 'readme') o.readme[lang].push(l);
    else if (sec === 'check') o.check.push(l);
    else if (sec === 'solution') o.solution.push(l);
    else if (l.trim()) err(n, 'text outside a section');
  });
  const fail = m => { throw new Error(`${path.basename(file)}: ${m}`); };
  if (!o.id || !/^(easy|medium|hard)-\d\d$/.test(o.id)) fail('@@sexam id must look like easy-01');
  if (path.basename(file) !== o.id + '.txt') fail(`file name must be ${o.id}.txt`);
  o.tier = o.id.split('-')[0];
  if (!o.script || !o.objectives.length || !o.readme.en || !o.readme.es || !o.check.length || !o.solution.length) fail('missing @@script, @@objectives, @@readme en/es, @@check or @@solution');
  const sum = o.objectives.reduce((s, x) => s + x.points, 0);
  if (sum !== TOTAL) fail(`objective points add up to ${sum}, not ${TOTAL}`);
  if (new Set(o.objectives.map(x => x.id)).size !== o.objectives.length) fail('duplicate objective id');
  const chk = o.check.join('\n');
  if (!/^\s*ARGS=\(/m.test(chk) || !/^\s*CASE_OBJ=\(/m.test(chk)) fail('@@check must define ARGS=( ... ) and CASE_OBJ=( ... )');
  return o;
}

function write(file, text, mode) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, text);
  if (mode) fs.chmodSync(file, mode);
}

function build(o) {
  const dir = path.join(OUT, `${o.id}_${o.slug}`);
  const TIER = { easy: ['easy', 'fácil'], medium: ['medium', 'medio'], hard: ['hard', 'difícil'] }[o.tier];
  const head = (lang) => lang === 'es'
    ? `# ${o.id} · ${o.title.es}\n\n**Nivel:** ${TIER[1]} · **Script:** \`${o.script}\`\n\n`
    : `# ${o.id} · ${o.title.en}\n\n**Tier:** ${TIER[0]} · **Script:** \`${o.script}\`\n\n`;
  write(path.join(dir, 'README.md'), head('en') + o.readme.en.join('\n').trim() + '\n');
  write(path.join(dir, 'README.es.md'), head('es') + o.readme.es.join('\n').trim() + '\n');
  const objs = o.objectives.map(x => `  "${x.id}|${x.label.en}|${x.points}"`).join('\n');
  write(path.join(dir, 'check.sh'),
    `# checker spec for the practice exam ${o.id} (see lib/engine.sh; graded by objectives with bin/sgrade)\nSCRIPT_NAME=${o.script}\nOBJECTIVES=(\n${objs}\n)\n${o.check.join('\n').trim()}\n`);
  write(path.join(dir, 'meta.json'), JSON.stringify({
    id: o.id, slug: o.slug, tier: o.tier, title: o.title, script: o.script, cmds: o.cmds,
    objectives: o.objectives, total: TOTAL,
  }, null, 1) + '\n');
  write(path.join(SOL, `${o.id}_${o.slug}.sh`), o.solution.join('\n').trim() + '\n', 0o755);
  return dir;
}

const files = process.argv.length > 2 ? process.argv.slice(2)
  : (fs.existsSync(SRC) ? fs.readdirSync(SRC).filter(f => f.endsWith('.txt')).sort().map(f => path.join(SRC, f)) : []);
let n = 0;
try {
  for (const f of files) { build(parse(f)); n++; }
} catch (e) { console.error('ERROR ' + e.message); process.exit(1); }
console.log(`built ${n} script exam(s) -> script-exams/, solutions/script-exams/`);
