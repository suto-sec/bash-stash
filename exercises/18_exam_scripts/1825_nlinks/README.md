# 1825 · Files with more than one hard link

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find -links, -printf %n, sort

Write `nlinks.sh [DIR]` (default: current directory) that prints, recursively and sorted by path,
every **regular file** under `DIR` that has more than one hard link, as `<path> <nlinks>`
(`nlinks` is the hard-link count, like `find -printf '%n'` or `stat -c %h`). Finally print
`Total: N files`.

Checks, in this order:
- more than 1 argument: usage on stderr, exit **1**.
- `DIR` is not a directory: message on stderr (naming `DIR`), exit **2**.

Directories are never listed (their own link count is unrelated to hard links between files).

---
Write your solution in `answer.sh`, then run `check 1825`.  
To experiment with the same test files the checker uses: `play 1825`.
