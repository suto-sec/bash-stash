# 0339 · cp -r: copying a directory

**Topic:** Files, copies & links · **Difficulty:** ★☆☆☆☆ · **Commands:** cp -r

`cp` refuses to copy a directory unless you add `-r` (recursive), which also copies everything inside it.

The current directory contains the directory `datos`, with a file inside. Copy the whole directory to a new one called `respaldo` (it does not exist yet) with a single `cp -r`. Nothing is printed.

Hint: `cp -r SOURCE DESTINATION`

---
Write your solution in `answer.sh`, then run `check 0339`.  
To experiment with the same test files the checker uses: `play 0339`.
