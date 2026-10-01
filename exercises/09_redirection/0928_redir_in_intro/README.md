# 0928 · Quick refresher: < (stdin from a file)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** <

`< file` makes a command read its input from a file, as if you typed the file's content on the keyboard.

Print the number of lines of `datos.txt` using `wc -l` and `<`. Do **not** pass the file name as an argument: `wc` should read it from the input redirection.

Example: for a file with 4 lines, print `4`.

Hint: `wc -l < file`
