# 0525 · A one-line text summary

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** wc -l -w -m -c -L, grep -c

Print **one single line** describing the file `texto.txt`, exactly in this format:

```
lines=L words=W chars=C bytes=B longest=X blank=E
```

- `L`, `W`, `B`: lines, words and bytes as `wc` counts them
- `C`: characters as `wc -m` counts them (the file has accented letters: in UTF-8 one character
  may take more than one byte, so `C` and `B` can differ)
- `X`: length of the longest line (see `wc -L`)
- `E`: number of **empty** lines (lines with nothing at all)

Print only the numbers, never the file name (`wc -l < file`).

---
Write your solution in `answer.sh`, then run `check 0525`.  
To experiment with the same test files the checker uses: `play 0525`.
