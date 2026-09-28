# 1813 · Finding duplicate files

**Topic:** Exam-style scripts · **Difficulty:** ★★★★★ · **Commands:** md5sum, sort, uniq, while read

Write `duplicados.sh [DIR]` (default: current directory) that finds groups of **non-empty regular files
with identical content** under `DIR` (recursively).

Print each group as its paths (sorted), one per line, groups separated by an empty line and ordered by
their first path. Finish with `N groups of duplicates` (preceded by an empty line if there was
at least one group). Not a directory: stderr, exit 1.

Hint: `md5sum` every file, sort by hash, keep hashes that appear more than once.

---
Write your solution in `answer.sh`, then run `check 1813`.  
To experiment with the same test files the checker uses: `play 1813`.
