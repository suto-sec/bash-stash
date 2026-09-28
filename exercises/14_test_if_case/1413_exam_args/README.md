# 1413 · The exam argument template

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** $#, test -e -d, >&2, exit codes

Write the argument validation of the exam-style deploy script (1801) (installed as `tool.sh`, usage `tool.sh [directory]`):

- more than one argument: message on stderr including the correct usage, exit **1**
- the argument doesn't exist: message on stderr **mentioning the name**, exit **2**
- it exists but is not a directory: message on stderr **mentioning the name**, exit **3**
- no argument: use the current directory

If everything is OK, print `Base directory: <dir>` where `<dir>` is the given argument, or `.` if
none was given, and exit 0. (Error message wording is free; the checker checks stderr is not empty,
the exit code and that the name appears.)

---
Write your solution in `answer.sh`, then run `check 1413`.  
To experiment with the same test files the checker uses: `play 1413`.
