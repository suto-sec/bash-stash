# 0501 · Counting with wc

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** wc -l, -w, -c

For the file `texto.txt` print, **only the numbers** (no file name), one per line:

1. its number of lines
2. its number of words
3. its number of bytes

Hint: `wc -l texto.txt` prints the name too; `wc -l < texto.txt` does not.

---
Write your solution in `answer.sh`, then run `check 0501`.  
To experiment with the same test files the checker uses: `play 0501`.
