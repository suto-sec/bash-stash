# 0538 · Byte histogram with od

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** od -An -v -tu1, tr -s, sort, uniq -c, head

Write a script `FILE` that prints the **5 most frequent byte values** of the file, one per line, as

```
VALUE COUNT
```

where VALUE is the byte value in **decimal** (0-255) and COUNT how many times it appears; most
frequent first, and for equal counts the smaller VALUE first. If there are fewer than 5 different
values, print them all. Then print a last line `distinct: D` with the number of different byte
values in the file (an empty file prints only `distinct: 0`).

Hint: `od -An -tu1` prints every byte as a decimal number. **Careful**: by default `od` replaces
repeated lines with a `*`; `-v` prints them all.

---
Write your solution in `answer.sh`, then run `check 0538`.  
To experiment with the same test files the checker uses: `play 0538`.
