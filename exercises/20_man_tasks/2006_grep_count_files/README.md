# 2006 · Errors per log

**Topic:** Exam tasks with the manual · **Difficulty:** ★★☆☆☆ · **Commands:** grep

The folder `logs` has several `.log` files. For each of them print its name (as `logs/<name>.log`), a colon, and the **number of lines that contain `ERROR`**, in the order of the `logs/*.log` glob.

Example: `logs/a.log:3`, then `logs/b.log:0`.

Do not count with `wc`: `grep` has an option that counts, and with several files it already writes the file names. Check it in `man grep`.
