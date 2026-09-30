# 1120 · gradebook.sh (averages with bc)

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★★☆ · **Commands:** bc, [[ =~ ]], read, exit codes

Write `gradebook.sh FILE [PASS]` (`PASS` default `5`). `FILE` has lines `NAME;S1;S2;S3`, where `NAME`
may contain spaces (but not `;`) and each `Si` is an integer **1-10**.

For every well-formed line (in file order) print:

```
NAME: avg=AVG (PASS|FAIL)
```

where `AVG` is the average of the three scores with **2 decimals** (`bc`), and the status is `PASS` if
`AVG >= PASS`, else `FAIL`. Finally print `Total: N students, P passed, F failed`.

- wrong number of arguments (not 1 or 2): usage on stderr, exit **1**
- `FILE` not readable: stderr, exit **2**
- `PASS` given but not an integer 0-10: stderr, exit **3**
- a line that doesn't match `NAME;S1;S2;S3` (wrong field count, a score that is not an integer, or
  outside 1-10) is **not** fatal: print `Error: line L: <line>` on stderr (L = line number, 1-based;
  blank lines don't count as errors and are skipped silently) and keep going. If this happened at
  least once, exit **4** at the end (only if there was no other error above); otherwise exit **0**.

---
Write your solution in `answer.sh`, then run `check 1120`.  
To experiment with the same test files the checker uses: `play 1120`.
