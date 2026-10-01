# 1538 · valida_usuarios.sh: validating records line by line

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** while IFS= read -r, IFS=: read, [[ =~ ]], case, exit codes

Write `valida_usuarios.sh FILE`. FILE contains records `user:uid:shell`, one per line; blank lines
and lines starting with `#` are ignored (but they count for line numbers). For each record line N,
apply these checks **in this order** and print the first one that fails (all on stdout):

| check | message |
|-------|---------|
| exactly 3 fields (exactly two `:`) | `line N: ERROR wrong field count` |
| user matches `^[a-z][a-z0-9]*$` | `line N: ERROR bad user name` |
| user not used by an earlier **OK** line | `line N: ERROR duplicate user USER` |
| uid only digits, value 1000–60000 | `line N: ERROR bad uid` |
| uid not used by an earlier **OK** line | `line N: ERROR duplicate uid UID` |
| shell is `/bin/bash`, `/bin/sh` or `/usr/sbin/nologin` | `line N: ERROR bad shell` |

If all pass print `line N: OK USER`. Finally print `valid V, invalid I` and exit with **4** if some
line was invalid, 0 otherwise.
Errors (stderr): not exactly 1 argument → **1** (usage); FILE not a readable regular file → **2**
(name it).
