#!/usr/bin/env node
// Lists the "Commands:" tokens of the exercises and scripts that the Reference manual cannot resolve to an entry yet.
//   node tools/manual_coverage.js [--all]     (--all also prints the resolved ones)
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const ROOT = path.join(__dirname, '..');
const PUB = path.join(ROOT, 'web/public');
const ctx = {}; vm.createContext(ctx);
vm.runInContext(fs.readFileSync(path.join(PUB, 'manual.js'), 'utf8') + ';globalThis.MANUAL = MANUAL;', ctx);
for (const f of fs.readdirSync(PUB).filter(f => /^manual-.*\.js$/.test(f)).sort()) vm.runInContext(fs.readFileSync(path.join(PUB, f), 'utf8'), ctx, { filename: f });
const M = ctx.MANUAL;

const toks = new Map();   // token -> count
const add = line => { for (const t of line.split(',')) { const k = t.trim(); if (k) toks.set(k, (toks.get(k) || 0) + 1); } };
for (const tier of fs.readdirSync(path.join(ROOT, 'exercises'))) {
  const d = path.join(ROOT, 'exercises', tier);
  if (!fs.statSync(d).isDirectory()) continue;
  for (const ex of fs.readdirSync(d)) {
    const f = path.join(d, ex, 'README.md');
    if (!fs.existsSync(f)) continue;
    const m = fs.readFileSync(f, 'utf8').match(/\*\*Commands:\*\*\s*(.*)$/m);
    if (m) add(m[1]);
  }
}
const SCR = path.join(ROOT, 'tools/src/scripts');
if (fs.existsSync(SCR)) for (const f of fs.readdirSync(SCR)) for (const m of fs.readFileSync(path.join(SCR, f), 'utf8').matchAll(/^@@cmds\s+(.*)$/gm)) add(m[1]);
let miss = 0;
for (const [t, n] of [...toks].sort((a, b) => b[1] - a[1])) {
  const e = M.lookup(t);
  if (!e) { miss++; console.log(`${String(n).padStart(4)}  ${t}`); } else if (process.argv.includes('--all')) console.log(`${String(n).padStart(4)}  ${t}  ->  ${e.key}`);
}
console.error(`${toks.size} distinct tokens, ${miss} unresolved`);
