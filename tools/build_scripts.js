#!/usr/bin/env node
// Builds the "Scripts" collection (one script built up in steps, every step validated) from tools/src/scripts/<NN>_<slug>.txt into
//   scripts/<id>_<slug>/{meta.json, README.<n>.md, check.<n>.sh}
//   solutions/scripts/<id>_<slug>/<n>.sh        (reference code of the script as it is at step n)
// Source format (details in tools/SCRIPTS_AUTHORING.md):
//   @@script s01 | slug | Title | script.sh
//   @@cmds echo, test, ...
//   @@fixture                  optional: setup() and helpers shared by every step (prepended to each step's checker)
//   @@step 1 | Step title
//   @@readme                   the statement of the step (markdown)
//   @@check                    checker spec for lib/engine.sh (ARGS, COMPARE, extra_check, ...)
//   @@solution                 reference code of the whole script at this step
// usage: node tools/build_scripts.js [source files...]
'use strict';
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const SRC = path.join(__dirname, 'src/scripts');
const OUT = path.join(ROOT, 'scripts');
const SOL = path.join(ROOT, 'solutions/scripts');
// sidebar / home groups, by script number
const GROUPS = [[1, 8, 'First steps'], [9, 20, 'Files and text'], [21, 30, 'Close to the exam']];
const groupOf = n => (GROUPS.find(g => n >= g[0] && n <= g[1]) || [0, 0, 'More'])[2];

function parse(file) {
  const lines = fs.readFileSync(file, 'utf8').split('\n');
  const o = { cmds: '', fixture: [], steps: [] };
  let sec = null, step = null;
  const fail = (n, m) => { throw new Error(`${path.basename(file)}${n == null ? '' : ':' + (n + 1)}: ${m}`); };
  lines.forEach((l, n) => {
    let m;
    if ((m = l.match(/^@@script\s+(s\d\d)\s*\|\s*([\w-]+)\s*\|\s*(.+?)\s*\|\s*(\S+\.sh)\s*$/))) { Object.assign(o, { id: m[1], slug: m[2], title: m[3], script: m[4] }); sec = null; return; }
    if ((m = l.match(/^@@cmds\s+(.*)$/))) { o.cmds = m[1].trim(); return; }
    if (/^@@fixture\s*$/.test(l)) { sec = 'fixture'; return; }
    if ((m = l.match(/^@@step\s+(\d+)\s*\|\s*(.+?)\s*$/))) {
      if (+m[1] !== o.steps.length + 1) fail(n, `steps must be numbered 1, 2, 3... (got ${m[1]})`);
      step = { n: +m[1], title: m[2], readme: [], check: [], solution: [] }; o.steps.push(step); sec = null; return;
    }
    if ((m = l.match(/^@@(readme|check|solution)\s*$/))) { if (!step) fail(n, `@@${m[1]} before any @@step`); sec = m[1]; return; }
    if (/^@@/.test(l)) fail(n, `unknown directive "${l.split(' ')[0]}"`);
    if (sec === 'fixture') o.fixture.push(l);
    else if (sec) step[sec].push(l);
    else if (l.trim()) fail(n, 'text outside a section');
  });
  if (!o.id) fail(null, 'missing @@script line');
  if (path.basename(file) !== `${o.id.slice(1)}_${o.slug}.txt`) fail(null, `file name must be ${o.id.slice(1)}_${o.slug}.txt`);
  if (!o.steps.length) fail(null, 'no steps');
  for (const s of o.steps) {
    if (!s.readme.join('').trim() || !s.solution.join('').trim() || !/^\s*ARGS=\(/m.test(s.check.join('\n'))) fail(null, `step ${s.n} needs @@readme, @@solution and a @@check that defines ARGS=( ... )`);
  }
  return o;
}

function write(file, text, mode) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, text);
  if (mode) fs.chmodSync(file, mode);
}

function build(o) {
  const dir = path.join(OUT, `${o.id}_${o.slug}`), sol = path.join(SOL, `${o.id}_${o.slug}`);
  fs.rmSync(dir, { recursive: true, force: true }); fs.rmSync(sol, { recursive: true, force: true });
  const group = groupOf(+o.id.slice(1));
  write(path.join(dir, 'meta.json'), JSON.stringify({ id: o.id, slug: o.slug, title: o.title, script: o.script, cmds: o.cmds, group,
    steps: o.steps.map(s => ({ n: s.n, title: s.title })) }, null, 1) + '\n');
  for (const s of o.steps) {
    write(path.join(dir, `README.${s.n}.md`), s.readme.join('\n').trim() + '\n');
    write(path.join(dir, `check.${s.n}.sh`), `# checker spec for ${o.id} step ${s.n} (see lib/engine.sh)\nSCRIPT_NAME=${o.script}\n${o.fixture.join('\n').trim()}\n${s.check.join('\n').trim()}\n`);
    write(path.join(sol, `${s.n}.sh`), s.solution.join('\n').trim() + '\n', 0o755);
  }
}

const files = process.argv.length > 2 ? process.argv.slice(2)
  : (fs.existsSync(SRC) ? fs.readdirSync(SRC).filter(f => /^\d\d_.*\.txt$/.test(f)).sort().map(f => path.join(SRC, f)) : []);
let n = 0;
try { for (const f of files) { build(parse(f)); n++; } } catch (e) { console.error('ERROR ' + e.message); process.exit(1); }
console.log(`built ${n} script(s) -> scripts/, solutions/scripts/`);
