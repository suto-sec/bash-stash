#!/usr/bin/env node
// Builds web/scanner-commands.json: the commands the course material itself uses (the checkers and solutions of the exercises, scripts and
// script exams). web/scanner.js warns about any other command in an imported pack. Run it again after adding material.
// usage: node tools/gen_scanner_commands.js
'use strict';
const fs = require('fs'), path = require('path');
const { commandWords } = require('../web/scanner.js');
const root = path.resolve(__dirname, '..');
const NEVER = new Set(['curl', 'wget', 'nc', 'ssh', 'sudo', 'python', 'python3', 'perl', 'git']);   // (a built-in test may mention them as data)
const walk = (d, f, out = []) => { try { for (const n of fs.readdirSync(d)) { const p = path.join(d, n); if (fs.statSync(p).isDirectory()) walk(p, f, out); else if (f(p)) out.push(p); } } catch { /* none */ } return out; };
const files = [
  ...walk(path.join(root, 'exercises'), p => /check\.sh$/.test(p)),
  ...walk(path.join(root, 'solutions'), p => /\.sh$/.test(p) && !/imp-/.test(p)),
  ...walk(path.join(root, 'scripts'), p => /check\.\d+\.sh$/.test(p) && !/imp-/.test(p)),
  ...walk(path.join(root, 'script-exams'), p => /check\.sh$/.test(p)),
];
const count = new Map();
for (const f of files) for (const w of commandWords(fs.readFileSync(f, 'utf8'))) count.set(w, (count.get(w) || 0) + 1);
const cmds = [...count.keys()].filter(w => !NEVER.has(w)).sort();
fs.writeFileSync(path.join(root, 'web/scanner-commands.json'), JSON.stringify(cmds) + '\n');
console.log(`${files.length} files, ${cmds.length} commands -> web/scanner-commands.json`);
