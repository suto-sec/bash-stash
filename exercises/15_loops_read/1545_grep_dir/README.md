# 1545 · grep_dir.sh: counting matches across a tree

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** find -print0, sort -z, while read -r -d '', grep -c

Write `grep_dir.sh DIR PATTERN`. Recursively visit every **regular file** under DIR (any depth,
hidden included), safely (`find DIR -type f -print0 | sort -z | while IFS= read -r -d '' f; do
... done`, names may contain spaces), and count its matching lines with `grep -c -- "$PATTERN" "$f"`.

For every file with **at least one** match, in that order, print `PATH: N`. Files with 0 matches
print nothing but still count as scanned. Finally print
`TOTAL: T matches in M files (of F escaneados)` (T = sum of matches, M = files with >=1 match,
F = files scanned).

Errors (stderr, wording free, checked in this order): not exactly 2 arguments -> usage, exit **1**;
DIR is not a directory -> exit **2** (name it); PATTERN is the empty string -> exit **3**.

---
Write your solution in `answer.sh`, then run `check 1545`.  
To experiment with the same test files the checker uses: `play 1545`.
