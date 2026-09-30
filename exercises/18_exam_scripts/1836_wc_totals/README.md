# 1836 · Line/word/byte totals by extension

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -name, wc -l -w -c

Write `wc_totals.sh DIR EXT`. For every **regular file** under `DIR` (recursively) whose name ends
in `.EXT` (`EXT` without a leading dot), sorted by path, print
`<path>: <lines> lines, <words> words, <bytes> bytes` (as `wc -l -w -c` reports for that single
file). Finally print `TOTAL: <files> files, <lines> lines, <words> words, <bytes> bytes`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `DIR` does not exist: message on stderr (naming `DIR`), exit **2**.
- `DIR` exists but is not a directory: message on stderr (naming `DIR`), exit **3**.

---
Write your solution in `answer.sh`, then run `check 1836`.  
To experiment with the same test files the checker uses: `play 1836`.
