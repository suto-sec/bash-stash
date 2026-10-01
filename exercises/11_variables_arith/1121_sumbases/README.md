# 1121 · sumbases.sh (multi-base sum)

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★★☆ · **Commands:** $((2#..)), $((8#..)), $((16#..)), [[ =~ ]]

Write `sumbases.sh FILE`. `FILE` has lines `BASE VALUE` (whitespace-separated), where `BASE` is one of
`bin`, `oct`, `dec`, `hex` and `VALUE` is a number written in that base (hex digits may be upper or
lower case).

For every well-formed line (in file order) print:

```
BASE VALUE = DECIMAL
```

Finally print `Sum: TOTAL` (the sum, in decimal, of every valid value) and `Skipped: K` (number of
invalid lines).

- not exactly 1 argument: usage on stderr, exit **1**
- `FILE` not readable: stderr, exit **2**
- no valid value at all in `FILE`: stderr, exit **3**
- a line that isn't `BASE VALUE` (unknown `BASE`, wrong digits for that base, or extra/missing fields)
  is skipped (counted in `Skipped`, reported as `Error: line L: <line>` on stderr, blank lines don't
  count); if at least one line was skipped, exit **4** at the end (only when there was no other error).
