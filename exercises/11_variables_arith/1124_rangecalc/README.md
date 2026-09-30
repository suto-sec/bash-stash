# 1124 · rangecalc.sh (stats with expr and bc)

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★★☆ · **Commands:** expr, bc, [[ =~ ]]

Write `rangecalc.sh FILE [THRESHOLD]` (`THRESHOLD` default `0`, may be negative). `FILE` has one
integer reading per line (may be negative). Blank lines are skipped silently.

Compute, over every well-formed line, using **`expr`** for the running sum and the "above threshold"
comparisons: the count, minimum, maximum, sum and how many readings are **strictly greater** than
`THRESHOLD`. Print:

```
Readings: N
Min: MIN
Max: MAX
Sum: SUM
Average: AVG
Above THRESHOLD: C
```

`AVG` is `SUM / N` with **1 decimal** (`bc`).

- wrong number of arguments (not 1 or 2): usage on stderr, exit **1**
- `FILE` not readable: stderr, exit **2**
- `THRESHOLD` given but not an integer: stderr, exit **3**
- a non-blank line that is not a plain integer is skipped: print `Error: line L: <line>` on stderr and
  keep going; if this happened at least once, exit **4** at the end (unless one of the errors below
  applies)
- if there is not a single valid reading in `FILE`: stderr, exit **5**

---
Write your solution in `answer.sh`, then run `check 1124`.  
To experiment with the same test files the checker uses: `play 1124`.
