# 1831 · Splitting a file into fixed-size chunks

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** split -l -d, ls, wc -l

Write `splitlines.sh FILE N` that splits `FILE` into chunks of at most `N` lines, equivalent to
`split -l N -d -a 2 FILE FILE.part` (parts named `FILE.part00`, `FILE.part01`... in the same
directory as `FILE`). Finally print `Created K parts` (K = number of part files written).

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `FILE` is not a readable regular file: message on stderr (naming `FILE`), exit **2**.
- `N` is not a positive integer: message on stderr, exit **3**.

---
Write your solution in `answer.sh`, then run `check 1831`.  
To experiment with the same test files the checker uses: `play 1831`.
