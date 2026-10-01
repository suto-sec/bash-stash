# 1828 · Files newer than a reference file

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find -newer, sort, wc -l

Write `newer_than.sh DIR REFFILE` that prints, recursively and sorted, the path of every
**regular file** under `DIR` that is strictly newer (modification time) than `REFFILE`
(`find -newer`), then `Total: N files`.

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `DIR` is not a directory: message on stderr (naming `DIR`), exit **2**.
- `REFFILE` does not exist: message on stderr (naming `REFFILE`), exit **3**.
