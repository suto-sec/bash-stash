# 1827 · Extracting a column from a CSV

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** cut -d, -f, wc -l

Write `csvcol.sh FILE COL` that prints the result of `cut -d, -f<COL> FILE` (COL is 1-based; a line
with fewer fields than `COL` behaves exactly as `cut` defines it), then a final line
`Total: N lines` where N is the number of lines of `FILE` (`wc -l`).

Checks, in this order:
- not exactly 2 arguments, or `COL` not a positive integer: usage on stderr, exit **1**.
- `FILE` is not a readable regular file: message on stderr (naming `FILE`), exit **2**.

---
Write your solution in `answer.sh`, then run `check 1827`.  
To experiment with the same test files the checker uses: `play 1827`.
