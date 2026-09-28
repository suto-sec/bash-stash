# 1502 · Looping over files (script_for_txt)

**Topic:** Loops: for, while, until, read · **Difficulty:** ★☆☆☆☆ · **Commands:** for f in *.txt

For every `.txt` file in the current directory (alphabetical), print `name: N lines` and create a copy
called `name.bak` (e.g. `a.txt.bak`), like `script_for_txt.sh` in `~/scripts.tgz`. If there are no `.txt`
files, print nothing (hint: without care, `*.txt` stays literally `*.txt`).

---
Write your solution in `answer.sh`, then run `check 1502`.  
To experiment with the same test files the checker uses: `play 1502`.
