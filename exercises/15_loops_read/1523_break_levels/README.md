# 1523 · break, continue and break 2

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while read -ra, for, break 2, continue

Each line of `matriz.txt` is a row of space-separated tokens (integers, and maybe the word `FIN`).
Process the rows in order, adding up the values of each row from left to right:

- a negative value is skipped (`continue`)
- a `0` ends the current row: the values after it are ignored (`break`)
- `FIN` ends the row **and the whole processing**: print that row's line (with its partial sum)
  and read no more rows (`break 2`)

For each processed row print `row R: S`, and at the end `rows: N, total: T` (N = rows printed,
T = sum of all the printed sums).
