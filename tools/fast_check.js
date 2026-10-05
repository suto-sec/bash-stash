#!/usr/bin/env node
// Validates web/public/fast-data.js (the fast track): every id must exist, none may appear twice, and it prints the planned time.
// usage: node tools/fast_check.js
'use strict';
const fs = require('fs'), path = require('path'), vm = require('vm');
const root = path.resolve(__dirname, '..');
const data = vm.runInNewContext(fs.readFileSync(path.join(root, 'web/public/fast-data.js'), 'utf8').replace(/^'use strict';/m, '') + '\n;FAST_DATA');
const ls = (d, f) => { try { return fs.readdirSync(path.join(root, d)).filter(f || (() => true)); } catch { return []; } };
const known = {
  ex: new Set(ls('exercises', n => /^\d\d_/.test(n)).flatMap(t => ls('exercises/' + t, n => /^\d{4}_/.test(n)).map(n => n.slice(0, 4)))),
  sc: new Set(ls('scripts', n => /^s\d\d_/.test(n)).map(n => n.slice(0, 3))),
  quiz: new Set(ls('theory', n => n.endsWith('.json')).map(n => n.replace(/\.json$/, ''))),
  exam: new Set(ls('theory/exams', n => n.endsWith('.json')).map(n => n.replace(/\.json$/, ''))),
  sx: new Set(ls('script-exams', n => /^(easy|medium|hard)-\d\d_/.test(n)).map(n => n.replace(/_.*$/, ''))),
  note: null,
};
let bad = 0, mins = 0;
const seen = {};
for (const b of data) {
  mins += b.mins;
  let core = 0, extra = 0;
  for (const [kind, id, flag] of b.items) {
    if (!(kind in known)) { console.log(`UNKNOWN KIND ${kind} in ${b.id}`); bad++; continue; }
    if (known[kind] && !known[kind].has(id)) { console.log(`UNKNOWN ${kind} ${id} in ${b.id}`); bad++; }
    if (seen[kind + id]) { console.log(`DUPLICATE ${kind} ${id} in ${b.id} (also ${seen[kind + id]})`); bad++; }
    seen[kind + id] = b.id;
    if (flag === 'x' || flag === 'o') extra++; else core++;
  }
  console.log(`${b.id.padEnd(4)} ${String(b.mins).padStart(4)} min  ${core} planned + ${extra} extra or optional  ${b.title}`);
}
console.log(`planned time ${(mins / 60).toFixed(1)}h`);
console.log(bad ? `${bad} problem(s)` : 'fast track data OK');
process.exit(bad ? 1 : 0);
