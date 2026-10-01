# 1830 · Counting files with an exact permission mode

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find -perm, sort, wc -l

Write `countperm.sh DIR MODE` (`MODE` is an octal permission like `chmod` accepts: 3 or 4 digits)
that prints, recursively and sorted, the path of every **regular file** under `DIR` whose
permission bits are **exactly** `MODE` (`find -perm MODE`, an exact match — a 3-digit `MODE` never
matches a file with the setuid/setgid/sticky bit set), then `Total: N files with mode MODE`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `DIR` is not a directory: message on stderr (naming `DIR`), exit **2**.
- `MODE` is not 3-4 octal digits: message on stderr, exit **3**.
