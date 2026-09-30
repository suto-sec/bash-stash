# 0826 · sshcheck.sh (like sshd's StrictModes)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** stat -c %a, test, chmod go= go-w, $HOME, options, exit codes

`sshd` refuses keys whose files have unsafe permissions. Write `sshcheck.sh [-f]` that checks the
user's own files, in this order:

1. `$HOME`: must not be **writable** by group or others. Fix: `chmod go-w`.
2. `$HOME/.ssh`: group and others must have **no** permission at all. Fix: `chmod go=`.
3. `$HOME/.ssh/authorized_keys` (only if it exists): no permission for group/others. Fix: `chmod go=`.
4. every **regular file** `$HOME/.ssh/id_*` **not** ending in `.pub` (private keys, glob order): no
   permission for group/others. Fix: `chmod go=`.
5. every **regular file** `$HOME/.ssh/*.pub` (glob order): not writable by group or others.
   Fix: `chmod go-w`.

Other files are not checked. For each problem print `BAD <path>: <mode>` or, with `-f`, fix it and print
`FIXED <path>: <old> -> <new>` (modes as `stat -c %a`; paths start with `$HOME` expanded, e.g.
`/home/alumno/.ssh/id_rsa`). Finally print `N problems found` (or with `-f`: `N problems fixed`).

Exit codes: **0** if there were no problems or `-f` fixed them; **1** if problems were found without
`-f`; **2** for wrong usage (any argument other than a single `-f`; usage on stderr); **3** if
`$HOME/.ssh` is not a directory (stderr message, nothing else is printed).

---
Write your solution in `answer.sh`, then run `check 0826`.  
To experiment with the same test files the checker uses: `play 0826`.
