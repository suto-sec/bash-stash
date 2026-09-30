# 1620 · buscar.sh: forwarding "$@" through two function layers

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** "$@" forwarding, grep -c, $(func), local

Write `buscar.sh PATTERN FILE...`. Write `procesar`, which receives `FILE...` and, for each one
(in order), calls a helper `contar FILE` (which **echoes** the number of matching lines,
`grep -c -- "$PATTERN" FILE`) and prints `FILE: N`; it tracks a running total of matches and of
valid files. The script calls `procesar "$@"` after removing PATTERN with `shift`, forwarding the
remaining file list with `"$@"` (arguments may contain spaces).

At the end `procesar` prints `TOTAL: T matches across F files`.

A FILE that doesn't exist or isn't readable is **not** fatal: print a message on stderr naming it
(wording free) and don't count it.

Errors (stderr, exit code, checked in this order):

| situation | exit |
|-----------|------|
| fewer than 2 arguments (show the usage) | 1 |
| PATTERN is the empty string | 2 |

---
Write your solution in `answer.sh`, then run `check 1620`.  
To experiment with the same test files the checker uses: `play 1620`.
