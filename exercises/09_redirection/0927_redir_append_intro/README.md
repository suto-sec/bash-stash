# 0927 · Quick refresher: >> (append)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** >>

`>>` also sends output into a file, but it **adds** to the end of the file instead of overwriting it.

`nota.txt` already contains one line. Add the line `fin` after it with `echo` and `>>`. Afterwards the file has two lines: `primera linea` and `fin`. Nothing is printed on the screen.

Hint: `command >> file`

---
Write your solution in `answer.sh`, then run `check 0927`.  
To experiment with the same test files the checker uses: `play 0927`.
