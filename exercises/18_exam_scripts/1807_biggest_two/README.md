# 1807 · The two biggest files

**Topic:** Exam-style scripts · **Difficulty:** ★★★☆☆ · **Commands:** find, stat / du -b, sort, head

Write `grandes.sh [dir]` (default: current directory) that prints the **two biggest regular files**
under `dir` (recursively), biggest first, as `<size in bytes> <path>` (path as `find` prints it).
Ties: path in alphabetical order (`sort -k1,1nr -k2`). If there's only one file print one line;
if none, print `No files` and exit 1. Not a directory: stderr, exit 2. Names may contain spaces.
