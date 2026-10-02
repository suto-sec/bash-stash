#!/usr/bin/env node
// Validates web/public/path-data.js (the exam path): every id must exist, none may appear twice, and it prints the size of each stage.
// usage: node tools/path_check.js
'use strict';
const fs = require('fs'), path = require('path'), vm = require('vm');
const root = path.resolve(__dirname, '..');
const src = fs.readFileSync(path.join(root, 'web/public/path-data.js'), 'utf8') + '\n;PATH_DATA';
const data = vm.runInNewContext(src);
const ls = (d, f) => { try { return fs.readdirSync(path.join(root, d)).filter(f || (() => true)); } catch { return []; } };
const known = {
  warm: new Set(ls('exercises', n => /^\d\d_/.test(n)).flatMap(t => ls('exercises/' + t, n => /^\d{4}_/.test(n)).map(n => n.slice(0, 4)))),
  sc: new Set(ls('scripts', n => /^s\d\d_/.test(n)).map(n => n.slice(0, 3))),
  quiz: new Set(ls('theory', n => n.endsWith('.json')).map(n => n.replace(/\.json$/, ''))),
  exam: new Set(ls('theory/exams', n => n.endsWith('.json')).map(n => n.replace(/\.json$/, ''))),
  sx: new Set(ls('script-exams', n => /^(easy|medium|hard)-\d\d_/.test(n)).map(n => n.replace(/_.*$/, ''))),
};
known.ex = known.warm;
let bad = 0;
const seen = {};
for (const st of data) {
  const row = [];
  for (const kind of ['warm', 'ex', 'sc', 'quiz', 'exam', 'sx']) {
    const ids = st[kind] || [];
    for (const id of ids) {
      if (!known[kind].has(id)) { console.log(`UNKNOWN ${kind} ${id} in stage ${st.id}`); bad++; }
      const k = kind === 'warm' ? 'ex' : kind;
      if (seen[k + id]) { console.log(`DUPLICATE ${kind} ${id} in ${st.id} (also ${seen[k + id]})`); bad++; }
      seen[k + id] = st.id;
    }
    row.push(`${kind}:${ids.length}`);
  }
  console.log(st.id.padEnd(10), row.join(' '));
}
const total = k => data.reduce((s, st) => s + (st[k] || []).length, 0);
console.log('total', ['warm', 'ex', 'sc', 'quiz', 'exam', 'sx'].map(k => `${k}:${total(k)}`).join(' '));
console.log(bad ? `${bad} problem(s)` : 'path data OK');
process.exit(bad ? 1 : 0);
