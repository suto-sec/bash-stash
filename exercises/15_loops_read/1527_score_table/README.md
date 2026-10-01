# 1527 · Formatting a table read from stdin

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while read, printf, [[ =~ ]], counters

Read lines `NAME SCORE` from **standard input** (SCORE integer 0–100). A valid line has exactly two
fields separated by blanks, and SCORE made only of digits with a value ≤ 100. For every valid line
print

```
printf '%-10s %3d %s\n' NAME SCORE STARS
```

where STARS is one `*` per full 10 points (SCORE / 10 stars). Every invalid line (including blank
ones) prints `skipped line N` on **stderr** (N = input line number).

Finally print `count: N, average: A` where A is the average with exactly 2 decimals, **truncated**
(not rounded), e.g. `66.66`; if there were no valid lines print `count: 0, average: -`.
