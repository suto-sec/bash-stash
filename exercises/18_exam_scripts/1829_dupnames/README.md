# 1829 · Filenames common to two directories

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find -maxdepth, sort, uniq -d

Write `dupnames.sh DIR1 DIR2` that prints, sorted, the **name** (basename) of every regular file
that exists **directly inside** both `DIR1` and `DIR2` (not recursive, hidden files ignored), then
`Total: N common names`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `DIR1` is not a directory: message on stderr (naming `DIR1`), exit **2**.
- `DIR2` is not a directory: message on stderr (naming `DIR2`), exit **3**.
