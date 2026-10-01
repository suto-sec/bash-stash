#!/usr/bin/env node
// Runs every example of the Reference manual (web/public/manual-*.js) for real, in a fresh empty directory, and stores what it printed in
// web/public/manual-outputs.json: the reference never shows an output nobody has seen. Run it INSIDE the lab container (same tools and
// locale as the terminal):   ./lab node tools/build_manual.js [--only key,key] [--check]
//   --only   run just those entries (the rest of the file is kept)
//   --check  run everything twice and report examples whose output changes (dates, pids, ...): mark those `norun` and give `out` by hand
// An example is { title, cmd, note?, fails?, norun?, out? }. `norun` examples are not executed (interactive, destructive, time-dependent...)
// and show `out`. A runnable example must exit with 0 unless it says `fails: true`. Examples are self-contained: they create their own
// inputs (printf, echo, mkdir, touch ...) so a reader can paste them into an empty directory.
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const { spawnSync } = require('child_process');

const PUB = path.join(__dirname, '../web/public');
const OUTFILE = path.join(PUB, 'manual-outputs.json');
const DEMO = '/tmp/demo';
const argv = process.argv.slice(2);
const only = argv.includes('--only') ? new Set(argv[argv.indexOf('--only') + 1].split(',')) : null;
const check = argv.includes('--check');

const ctx = {};
vm.createContext(ctx);
vm.runInContext(fs.readFileSync(path.join(PUB, 'manual.js'), 'utf8') + ';globalThis.MANUAL = MANUAL;', ctx);
for (const f of fs.readdirSync(PUB).filter(f => /^manual-.*\.js$/.test(f)).sort()) vm.runInContext(fs.readFileSync(path.join(PUB, f), 'utf8'), ctx, { filename: f });
const M = ctx.MANUAL;

let problems = 0;
const warn = m => { problems++; console.log('  ! ' + m); };

function run(cmd) {
  fs.rmSync(DEMO, { recursive: true, force: true });
  fs.mkdirSync(DEMO, { recursive: true });
  const r = spawnSync('sh', ['-c', 'exec bash -c "$0" 2>&1', cmd], {
    cwd: DEMO, encoding: 'utf8', timeout: 15000, input: '', maxBuffer: 1 << 20,
    env: { HOME: DEMO, PATH: process.env.PATH, LANG: 'en_US.UTF-8', TZ: 'UTC', TERM: 'dumb', USER: 'user', LOGNAME: 'user', SHELL: '/bin/bash' },
  });
  const out = (r.stdout || '').replace(/\n+$/, '').split(DEMO).join('/home/user/demo');
  return { out, status: r.status === null ? 'timeout' : r.status };
}

const outputs = fs.existsSync(OUTFILE) && only ? JSON.parse(fs.readFileSync(OUTFILE, 'utf8')) : {};
const entries = M.all();
const seenAlias = new Map();
let ran = 0;
for (const e of entries) {
  const tag = `${e.cat}/${e.key}`;
  if (!e.name || !e.summary) warn(`${tag}: name and summary are required`);
  if (!e.synopsis || !e.synopsis.length) warn(`${tag}: no synopsis`);
  if (!e.examples || e.examples.length < 2) warn(`${tag}: fewer than 2 examples`);
  for (const k of e.see || []) if (!M.get(k)) warn(`${tag}: "see" points to unknown entry "${k}"`);
  for (const a of e.aliases || []) {
    const n = a.trim().toLowerCase();
    if (seenAlias.has(n) && seenAlias.get(n) !== e.key) warn(`${tag}: alias "${a}" is also an alias of ${seenAlias.get(n)}`);
    seenAlias.set(n, e.key);
  }
  if (only && !only.has(e.key)) continue;
  (e.examples || []).forEach((x, i) => {
    const id = `${e.key}#${i}`;
    if (!x.cmd) { warn(`${tag} example ${i + 1}: no cmd`); return; }
    if (x.norun) { if (!x.out && x.out !== '') warn(`${tag} example ${i + 1}: norun needs an out`); delete outputs[id]; return; }
    const a = run(x.cmd);
    if (check) { const b = run(x.cmd); if (a.out !== b.out) warn(`${tag} example ${i + 1} ("${x.title}") is not deterministic`); }
    if (a.status !== 0 && !x.fails) warn(`${tag} example ${i + 1} ("${x.title}") exited with ${a.status}:\n${a.out.split('\n').map(l => '      ' + l).join('\n')}`);
    outputs[id] = a.out;
    ran++;
  });
}
const sorted = Object.fromEntries(Object.keys(outputs).sort().map(k => [k, outputs[k]]));
fs.writeFileSync(OUTFILE, JSON.stringify(sorted, null, 1) + '\n');
fs.rmSync(DEMO, { recursive: true, force: true });
console.log(`${entries.length} entries, ${ran} examples run, ${Object.keys(sorted).length} outputs stored, ${problems} problem(s)`);
process.exit(problems ? 1 : 0);
