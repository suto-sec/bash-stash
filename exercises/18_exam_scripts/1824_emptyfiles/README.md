# 1824 · Finding empty files

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find -empty, sort, wc -l

Write `emptyfiles.sh [DIR]` (default: current directory) that prints, recursively and sorted, the
path of every **regular empty file** under `DIR`, then a final line `Total: N empty files`.

Checks, in this order:
- more than 1 argument: usage on stderr, exit **1**.
- `DIR` is not a directory: message on stderr (naming `DIR`), exit **2**.

Empty directories and symbolic links are never listed, even if they point to an empty file. File
names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 1824`.  
To experiment with the same test files the checker uses: `play 1824`.
