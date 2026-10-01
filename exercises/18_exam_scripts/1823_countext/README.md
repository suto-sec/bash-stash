# 1823 · Counting files by extension

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find -name, sort, wc -l

Write `countext.sh DIR EXT` (both arguments mandatory) that prints, sorted, the path of every
**regular file** under `DIR` (recursively) whose name ends in `.EXT` (`EXT` is given **without** a
leading dot, matched literally and case-sensitively), then a final line
`Total: N files with extension .EXT`.

Checks, in this order:
- not exactly 2 arguments: usage message on stderr, exit **1**.
- `DIR` is not a directory: message on stderr (naming `DIR`), exit **2**.

File names may contain spaces.
