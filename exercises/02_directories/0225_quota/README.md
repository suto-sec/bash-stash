# 0225 · cuota.sh: which directories are over the limit

**Topic:** Directories & navigation · **Difficulty:** ★★★★☆ · **Commands:** du -sk, cut, for d in "$DIR"/*/, [[ =~ ]], $(( ))

Write `cuota.sh`:

```
cuota.sh DIR LIMIT
```

`LIMIT` is a size: a positive integer optionally followed by `K` (KiB, the default unit) or `M` (MiB,
i.e. × 1024 KiB), e.g. `300`, `300K`, `2M`.

For each subdirectory **directly inside** `DIR` (not hidden; in the order of the glob `DIR/*/`),
compute its disk usage in KiB with `du -sk` and print

```
<name>: <S> KiB ok
<name>: <S> KiB OVER
```

(`<name>` is the subdirectory name without path; `OVER` when S is **strictly greater** than the limit).
Then print `N of M directories over the limit (L KiB)` where L is the limit converted to KiB.

Errors (message on stderr, nothing on stdout), checked in this order:

- not exactly 2 arguments: usage, exit **1**
- `DIR` is not a directory: exit **2** (mention it)
- `LIMIT` is not valid (`0`, `0M`, `-5`, `5G`, `2.5M`, `abc`, `M`...): exit **3** (mention it)

---
Write your solution in `answer.sh`, then run `check 0225`.  
To experiment with the same test files the checker uses: `play 0225`.
