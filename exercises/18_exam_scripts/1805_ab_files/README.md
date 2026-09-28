# 1805 · Names starting with a or b

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find \( -o \) !, wc

Write `ab.sh [dir]` (default: current directory) that prints, recursively and sorted, every file and
directory under `dir` whose **name** starts with `a` or `b` and does **not** contain `~`, and finally
`N entries`. `dir` itself is never listed. If `dir` doesn't exist or isn't a directory: stderr, exit 1.

---
Write your solution in `answer.sh`, then run `check 1805`.  
To experiment with the same test files the checker uses: `play 1805`.
