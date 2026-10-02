# 2016 · nuevo.sh: which file is newer

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★★☆ · **Commands:** test, if, exit codes

Write a script `nuevo.sh` that takes **two file names** and prints the name of the one that was **modified more recently**.

- If it does not receive exactly two arguments: print on standard error a message with the correct use and exit with code `1`.
- If one of the files does not exist: print on standard error a message that names it and exit with code `2`.
- Otherwise print the name of the newer file and exit with code `0`.

Example: `./nuevo.sh a b` prints `b` if `b` is newer than `a`.

You do not need `ls` or `stat`: the `test` / `[ ]` command compares the age of two files. Find the operator in `man test`.
