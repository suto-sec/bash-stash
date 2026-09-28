# 1804 · Recursive chmod +x of scripts

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find, chmod +x, test -x

Write `addexec.sh [dir]` (default: current directory) that adds execute permission (`chmod +x`) to
**every regular file** ending in `.sh` under `dir`, recursively.

Print (sorted) the path of each file that **did not already have** execute permission for
user, group **and** others (i.e. the ones whose permissions actually change), then
`Updated N files`. If `dir` is not a directory: stderr message, exit 1.

---
Write your solution in `answer.sh`, then run `check 1804`.  
To experiment with the same test files the checker uses: `play 1804`.
