# 2005 · Lines in all the .txt files

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** find, cat, wc

The folder `docs` contains `.txt` files at several levels, plus files with other extensions.

Print the **total number of lines** of all the `.txt` files under `docs` (only the number).

Use a single `find` that runs `cat` for the selected files, and count with `wc`. In `man find`, read the two forms of `-exec`: `{} \;` and `{} +`; which one is better here?
