# 1426 · check_users.sh: validating user records

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** [[ =~ ]], case, IFS=: read, test -ge -le, exit codes

Write `check_users.sh file`. Every line of `file` should be a user record

```
name:uid:shell:home
```

Blank lines and lines starting with `#` are ignored. For every other line (numbered counting
**all** lines of the file) print either `line N: OK (<name>)` or `line N: <reason>`, where the
reason is the **first** failing rule of:

| rule | reason |
|------|--------|
| exactly 4 fields (3 colons) | `wrong number of fields` |
| `name`: a lowercase letter or `_`, followed by up to 15 lowercase letters, digits, `_` or `-` | `bad name` |
| `uid`: an integer from 1000 to 60000 (digits, not starting with 0) | `bad uid` |
| `shell`: one of `/bin/bash`, `/bin/sh`, `/usr/bin/zsh`, `/usr/sbin/nologin` | `bad shell` |
| `home`: exactly `/home/<name>` | `bad home` |

Finally print `Valid: V, invalid: I`.

Exit codes:

| situation | exit |
|-----------|------|
| every record valid | 0 |
| some record invalid | 1 |
| not exactly one argument (usage on stderr) | 2 |
| `file` is not a readable regular file (stderr, name it) | 3 |
| the file has no records at all (only blank/comment lines; stderr message, nothing on stdout) | 4 |

---
Write your solution in `answer.sh`, then run `check 1426`.  
To experiment with the same test files the checker uses: `play 1426`.
