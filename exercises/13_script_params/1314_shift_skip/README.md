# 1314 · shift N and its exit status

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** shift, shift N, $#, exit

Write `skip.sh N [arg...]`. The first argument `N` says how many of the **following** arguments must
be skipped. Print each remaining argument on its own line as `> arg`, and then `(K left)` where K is
the number of remaining arguments.

Use `shift` to drop `N` itself and then `shift "$N"`. When there are fewer than `N` arguments left,
`shift N` **does nothing and returns a non-zero status**: use that status to detect the problem.

Errors (message on **stderr**, exact text):

| situation | message | exit |
|-----------|---------|------|
| no arguments | `Usage: skip.sh N [arg...]` (use `$(basename "$0")`) | 1 |
| `N` is not a non-negative integer (only digits) | `Invalid count: N` | 2 |
| fewer than `N` arguments after `N` | `Cannot skip N of M arguments` (M = how many there were) | 3 |

Example: `skip.sh 2 a b c d` prints `> c`, `> d`, `(2 left)`.

---
Write your solution in `answer.sh`, then run `check 1314`.  
To experiment with the same test files the checker uses: `play 1314`.
