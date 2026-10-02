# 2008 · A whole word, any case

**Topic:** Exam tasks with the manual · **Difficulty:** ★★☆☆☆ · **Commands:** grep

`usuarios.txt` has one name per line. Print the lines that contain the **word `ana`** (in upper or lower case, in any position), each one **preceded by its line number and a colon**, as `grep` writes it. Names like `mariana` or `anabel` do **not** count: it must be the whole word.

Example: for `Ana Ruiz` on line 3 the output includes `3:Ana Ruiz`.

Three options of `grep` do this: ignoring case, whole words and line numbers. Find them in `man grep`.
