# 0560 · head and tail: first/last lines

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** head -n, tail -n

`head` prints the first lines of a file and `tail` the last ones. `-n N` chooses how many.

For the file `datos.txt` (it has between 8 and 12 lines), print, with a line `---` in between:

1. its first 3 lines
2. its last 2 lines

Example: if `datos.txt` contains the lines `1 pera`, `2 uva`, `3 kiwi`, `4 fresa`, `5 limon`, `6 mora`, the output is:

```
1 pera
2 uva
3 kiwi
---
5 limon
6 mora
```

Hint: `head -n 3 file`, `tail -n 2 file`, and `echo ---` prints the separator.
