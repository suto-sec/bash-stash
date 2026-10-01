# 1123 · portfolio.sh (holdings with bc)

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★★☆ · **Commands:** declare -A, bc, read

Write `portfolio.sh FILE`. `FILE` has lines `SYMBOL QTY PRICE` (whitespace-separated): `SYMBOL` is
1-5 uppercase letters, `QTY` a positive integer, `PRICE` a positive number with exactly 2 decimals.
The same `SYMBOL` may appear on several lines: accumulate its `QTY` and keep the `PRICE` of its
**last** occurrence.

Print, for every distinct symbol sorted alphabetically:

```
SYMBOL: QTY units, value=VALUE
```

where `VALUE = QTY * PRICE` with **2 decimals** (`bc`). Finally print
`Total portfolio value: TOTAL` (sum of every `VALUE`, 2 decimals).

- not exactly 1 argument: usage on stderr, exit **1**
- `FILE` not readable: stderr, exit **2**
- no valid holding at all: stderr, exit **3**
- a line that isn't `SYMBOL QTY PRICE` (bad symbol, `QTY` not a positive integer, `PRICE` not
  `DIGITS.DD`, or extra/missing fields) is skipped: print `Error: line L: <line>` on stderr (blank
  lines don't count) and, if at least one such line was found, exit **4** at the end (only when there
  was no other error).
