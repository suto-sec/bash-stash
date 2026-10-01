#!/usr/bin/env node
// Generates tools/theory/exams/blueprint.json: for every practice exam (easy-01 ... hard-NN) and each of its 10
// questions, the T1 topic, the subtopic to test and a suggested question style. It is what keeps the coverage even when
// several people / agents write sets independently; build_theory.js checks that question N of a set uses the topic
// assigned to slot N. Deterministic: running it again gives the same file.
//   usage: node tools/exam_blueprint.js [setsPerTier=7]
//   sets whose source file already exists keep their old slots; only the others are (re)dealt
'use strict';
const fs = require('fs');
const path = require('path');

const PER_TIER = Number(process.argv[2] || 7);
const SIZE = 10;
const TIERS = ['easy', 'medium', 'hard'];

// topic -> relative weight (about how much T1 slide / cheat-sheet / activity material it has) and its subtopics
const TOPICS = {
  'files-fs': { w: 11, subs: ['absolute vs relative paths, ., .., ~, $HOME, cd and pwd', 'ls options (-a -l -R -i -d) and hidden files', 'mkdir -p and rmdir (empty directories only)',
    'cp options (-r -u -a -i) and what happens to the destination', 'mv: rename vs move, destination is an existing directory', 'rm -r -f -i and removing directories', 'touch (create / change times) and mktemp',
    'hard links: link count, shared inode, surviving deletion', 'symbolic links: contents, broken links, ln -s argument order', 'inodes: what a directory entry and an inode each hold',
    'mount / umount: what is hidden by a mount point', 'df and du (-h -s depth) and what each measures', 'tar: c x t z v f, and archive vs compression (gzip, compress)', 'tree and the single Linux directory tree', 'case sensitivity and file names'] },
  'expansion-vars': { w: 10, subs: ['order of evaluation of a command line (tokens, alias, variables, wildcards, redirections)', 'alias and unalias', 'assigning variables (no spaces) and $VAR vs ${VAR}', 'export, env, printenv, unset: what children inherit',
    'predefined variables HOME PATH HOSTNAME and which', 'arithmetic: expr, bc, $(( )) and variables as strings', 'wildcards * ? [list] [!list] [range] and who expands them', 'command substitution $( ) and backticks',
    'quoting: double quotes, single quotes, backslash', 'echo options and escapes (-e, \\n, \\t)', 'startup files: .bashrc, /etc/profile, what they customize'] },
  'scripts': { w: 10, subs: ['shebang and execute permission', 'running a script: ./s, bash s, source / . s - which shell, which directory, which variables survive', 'finding a script through the PATH', 'positional parameters $0 $1 $#',
    '$* vs $@ and "$@"', '$? and exit codes, exit n', 'test / [ ] with numbers (-eq -ne -lt -le -gt -ge)', 'test with strings (-z -n = !=) and files (-e -f -d -s)', 'if / elif / else structure and its syntax',
    'case patterns and ;;', 'for loops: for v, for v in list, globs, seq, brace ranges', 'while and until', 'read (-p -t) and interactive scripts', 'functions: parameters, return vs exit, scope', 'shift, comments and multi-line commands'] },
  'jobs-procs': { w: 9, subs: ['foreground vs background and the & operator', 'Ctrl+C vs Ctrl+Z (terminate vs suspend)', 'jobs, bg and fg and job numbers', 'ps: default columns and common options (-e -l -a, aux, a x u f r t)', 'PIDs: sequential assignment, limit, PID 1',
    'process types: interactive, batch, daemon', 'process state codes R S T D Z', 'top: sorting, refresh, interaction', 'pstree and the parent/child tree', 'kill: signals, kill -l, SIGTERM vs SIGKILL (-9)', 'builtin vs external commands and what a subshell is'] },
  'redirection-pipes': { w: 9, subs: ['stdin, stdout, stderr and their defaults', '> vs >> and what happens to an existing file', '< and commands that read stdin vs files', '2> and redirecting only errors', '2>&1 and &> and why the order of redirections matters',
    '/dev/null', 'pipes: what flows from one command to the next', 'tee and splitting an output', 'xargs vs command substitution for commands that take arguments, not stdin', 'here-document and here-string', 'building multi-stage pipelines from filters', 'exit status of a pipeline and subshell grouping'] },
  'permissions': { w: 8, subs: ['reading the ls -l mode string (type, owner, group, others)', 'what r, w, x mean on a regular file', 'what r, w, x mean on a directory', 'chmod symbolic mode (u g o a, + - =)', 'chmod octal mode', 'umask: computing the permissions of new files and directories',
    'chown and chgrp, and who may change owner or mode', 'the special status of root regarding permissions', 'execute permission and scripts', 'permissions of symbolic links', 'permissions needed to delete, rename or create inside a directory'] },
  'filters': { w: 8, subs: ['wc and its options', 'cut: -d, -f, -c', 'head and tail, including -n and -n+p', 'sort options: -r -u -n -t -k', 'tr: translate and delete characters', 'sed s///, the g flag and d', 'cat, tac, nl, more, less: showing files',
    'tee, paste, split', 'od, cmp, diff', 'which tools are filters (stdin to stdout) and which are not', 'combining two filters for a typical task'] },
  'shell-help': { w: 7, subs: ['what a shell is and the read-evaluate loop', 'builtin vs external commands, type / which / whereis', 'the PATH and invoking an executable by path', 'man sections and man N name', 'whatis, apropos, man -k', 'less key bindings', 'info structure and keys (n p u l t q)',
    'command line editing and history (Tab, Ctrl+A / E / R, arrows)', 'exit status as true/false', 'several commands per line (;) and line continuation'] },
  'grep-regex': { w: 7, subs: ['grep options -c -i -v -n -l', 'grep -r / -E / -f and the egrep / fgrep names', 'BRE: . ^ $ and anchors', 'BRE: * and character classes [abc] [^abc] [a-z]', 'ERE: + ? | and groups', 'word boundaries and matching whole words',
    'globs vs regular expressions (the same symbol, different meaning)', 'interpreting a regex on a word list', 'escaping special characters'] },
  'users-sessions': { w: 7, subs: ['root: UID 0, why not to work as root', 'adduser, deluser, addgroup, delgroup', 'su, su - and sudo: differences', '/etc/sudoers entries (user, %group, NOPASSWD, aliases)', '/etc/passwd fields', '/etc/shadow and its permissions', '/etc/group and membership',
    'passwd options (-l -u -e)', 'sessions: tty, pts/N, :0 and what who shows', 'whoami, id, groups, who, w, last', 'login configuration files (/etc/profile, ~/.profile, ~/.bashrc)'] },
  'boot-systemd': { w: 6, subs: ['order of the boot sequence', 'BIOS vs UEFI and Secure Boot', 'MBR vs GPT', 'boot loader: first and second stage', 'GRUB files: /boot/grub, grub.cfg, /etc/default/grub, update-grub', 'the GRUB command line and chain loading',
    'what the kernel does at start, initrd and PID 0 / PID 1', 'init styles: SysV, systemd, launchd, BSD', 'systemd units, targets and cgroups', 'runlevels vs targets, systemctl get-default / isolate', 'systemctl start stop restart enable disable status', 'shutdown options and the shutdown sequence (SIGTERM then SIGKILL)'] },
  'find': { w: 5, subs: ['-name (quoting the pattern) and -type', '-size with units and +/-', '-perm: exact, any (/), all (-)', '-user / -group', '-mtime / -atime / -ctime', '-maxdepth', '-exec ... {} \; and -delete', 'find with xargs / -print0 / command substitution', 'combining tests (implicit AND, -o)'] },
  'logs-cron': { w: 3, subs: ['what /var/log/auth.log records', 'extracting information from a log with grep / tail / wc / sort', 'cron schedule fields and common schedules', 'crontab -e / -l and where cron output goes', 'argument checking and exit codes in a log-analysis script', 'printing user, date and shell version in a script'] },
};
const STYLES = {
  easy:   ['which command / option does X', 'which statement is TRUE', 'what does this single command print or do', 'definition / concept recall', 'which statement is FALSE'],
  medium: ['trace the output of a short command or pipeline', 'scenario: what happens when ...', 'which command achieves this task', 'which statement is FALSE', 'compare two similar commands / options'],
  hard:   ['multi-step trace with a twist', 'subtle option / syntax trap', 'scenario combining two concepts', 'find what is wrong with this line / script', 'edge case (existing file, empty input, spaces, order of redirections)'],
};

function rng(seed) { let a = seed >>> 0; return () => { a = (a + 0x6D2B79F5) >>> 0; let t = a; t = Math.imul(t ^ (t >>> 15), t | 1); t ^= t + Math.imul(t ^ (t >>> 7), t | 61); return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }
const shuffle = (a, r) => { a = a.slice(); for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };

// questions per topic in one tier: largest remainder of PER_TIER * SIZE * weight / total
function quotas() {
  const total = PER_TIER * SIZE, wsum = Object.values(TOPICS).reduce((s, t) => s + t.w, 0);
  const q = {}, rem = [];
  let used = 0;
  for (const [id, t] of Object.entries(TOPICS)) { const x = total * t.w / wsum; q[id] = Math.floor(x); used += q[id]; rem.push([x - q[id], id]); }
  rem.sort((a, b) => b[0] - a[0]);
  for (let i = 0; used < total; i++, used++) q[rem[i][1]]++;
  return q;
}

const file = path.join(__dirname, 'theory/exams/blueprint.json');
// sets that already have a source file keep the slots they were written to (so shrinking or growing the number of sets
// never invalidates written questions); the remaining quota is dealt over the other sets
let old = {};
try { old = JSON.parse(fs.readFileSync(file, 'utf8')).sets || {}; } catch (e) { /* first run */ }
const written = id => fs.existsSync(path.join(__dirname, 'theory/exams', id + '.txt'));

const out = { setsPerTier: PER_TIER, questionsPerSet: SIZE, topicQuota: quotas(), sets: {} };
TIERS.forEach((tier, ti) => {
  const ids = Array.from({ length: PER_TIER }, (_, si) => `${tier}-${String(si + 1).padStart(2, '0')}`);
  const locked = ids.filter(id => old[id] && written(id));
  const free = ids.filter(id => !locked.includes(id));
  const seen = {}, left = Object.assign({}, out.topicQuota);
  for (const id of locked) {
    out.sets[id] = old[id];
    for (const row of old[id]) { seen[tier + row.topic] = (seen[tier + row.topic] || 0) + 1; left[row.topic] = (left[row.topic] || 0) - 1; }
  }
  // topic tokens still to be placed, one per question of the free sets; topics over their quota are not dealt again
  const tokens = [];
  for (const id of Object.keys(TOPICS)) for (let k = 0; k < Math.max(0, left[id]); k++) tokens.push(id);
  const need = free.length * SIZE;
  const room = Object.keys(TOPICS).sort((x, y) => left[y] - left[x]);
  for (let i = 0; tokens.length < need; i++) tokens.push(room[i % room.length]);   // quotas clamped: top up with the least used topics
  tokens.length = need;
  tokens.sort((x, y) => Object.keys(TOPICS).indexOf(x) - Object.keys(TOPICS).indexOf(y));
  const sets = free.map(() => []);
  tokens.forEach((t, i) => sets[i % free.length].push(t));
  sets.forEach((topics, fi) => {
    const id = free[fi], r = rng(1000 * (ti + 1) + ids.indexOf(id));
    const styles = shuffle([...STYLES[tier], ...STYLES[tier]], r);
    out.sets[id] = shuffle(topics, r).map((topic, n) => {
      const subs = TOPICS[topic].subs, k = seen[tier + topic] = (seen[tier + topic] || 0);
      seen[tier + topic]++;
      return { n: n + 1, topic, sub: subs[(k + ti * 4) % subs.length], style: styles[n] };
    });
  });
  out.sets = Object.fromEntries(Object.entries(out.sets).sort(([x], [y]) => x < y ? -1 : 1));
});
fs.mkdirSync(path.dirname(file), { recursive: true });
fs.writeFileSync(file, JSON.stringify(out, null, 1) + '\n');
console.log(`blueprint: ${Object.keys(out.sets).length} sets x ${SIZE} questions -> ${path.relative(process.cwd(), file)}`);
console.log('topic quota per tier:', JSON.stringify(out.topicQuota));
