# 1526 · find -print0 with really weird names

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** find -print0, sort -z, read -d '', stat

Under `datos` there are files whose names contain spaces and even a **newline**. The script
receives a size MIN (bytes). For every regular file under `datos` with size **≥ MIN**, in the order
given by `sort -z`, print:

```
PATH (SIZE bytes)
```

where every newline in PATH is shown as `?`. Finally print `N files, S bytes` (the listed files).

A `for f in $(find ...)` breaks on these names: use `find ... -print0` and
`while IFS= read -r -d '' f`, and make sure the counters survive the loop.

---
Write your solution in `answer.sh`, then run `check 1526`.  
To experiment with the same test files the checker uses: `play 1526`.
