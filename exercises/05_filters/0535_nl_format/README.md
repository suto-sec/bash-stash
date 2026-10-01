# 0535 · Custom numbering with nl

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** nl -b -v -i -w -s -n

Print the file `programa.bas` numbered in two ways, separated by a line `---`:

1. **BASIC style**: **all** lines (empty ones too) numbered 10, 20, 30...; the number right-aligned
   in a field of 4 characters, followed by `: ` and the line. Example: `  10: PRINT "hello"`
2. only the **non-empty** lines numbered 1, 2, 3...; the number with 2 digits padded with **zeros**,
   followed by one space and the line (`01 PRINT "hello"`). Empty lines are printed but not
   numbered (they may come out as spaces: the checker ignores trailing whitespace).

`nl` can do both (look at `-b`, `-v`, `-i`, `-w`, `-s`, `-n` in `man nl`).
