# 0334 · rotate_backup.sh: numbered backups that shift instead of collide

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** mv, cp -p, for (( )), exit codes

Write `rotate_backup.sh`:

```
rotate_backup.sh FILE N
```

Keeps up to `N` rotating backups of `FILE` as `FILE.1` (most recent backup) through `FILE.N`
(oldest). Each run:

1. shifts the existing backups **one slot older**, from the oldest end first: `FILE.(N-1)` becomes
   `FILE.N` (silently discarding whatever used to be `FILE.N`), then `FILE.(N-2)` becomes
   `FILE.(N-1)`, ... down to `FILE.1` becoming `FILE.2`. Missing slots are simply skipped (nothing to
   shift). Print `FILE.k -> FILE.k+1` for every shift actually performed, from the highest `k` down
   to the lowest, in that order — going the other way around would silently destroy backups before
   they are shifted.
2. copies `FILE` to `FILE.1`, preserving its permissions and modification time (`cp -p`), and prints
   `Saved FILE as FILE.1`.
3. prints `K backups now`, where `K` is how many of `FILE.1`..`FILE.N` exist after step 2.

`FILE` itself is left untouched. Names may contain spaces.

Errors (message on stderr):

- not exactly 2 arguments → usage, exit **1**
- `FILE` is not a regular file → exit **2** (message includes `FILE`)
- `N` is not a positive integer → exit **3** (message includes `N`)

---
Write your solution in `answer.sh`, then run `check 0334`.  
To experiment with the same test files the checker uses: `play 0334`.
