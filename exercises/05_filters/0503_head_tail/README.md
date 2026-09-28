# 0503 · head and tail

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** head, tail

`passwd` is a copy of a `/etc/passwd`-like file. Print, in this order, separated by a line `---`:

1. its first 5 lines
2. its last 3 lines
3. its first 50 **bytes** (then print an empty line with `echo`, since they don't end in newline)

---
Write your solution in `answer.sh`, then run `check 0503`.  
To experiment with the same test files the checker uses: `play 0503`.
