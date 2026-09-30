# 0622 · Which files do (not) contain it

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -r -l -L, --include, grep -w

The directory `proyecto` contains text files in several subdirectories (names may contain spaces).
Print, separated by `---` (paths as `grep -r ... proyecto` prints them, each list sorted):

1. the `.txt` files (recursively) that do **not** contain `DONE` (exact case, anywhere in a line)
2. the `.md` files (recursively) that contain `DONE` as a **whole word** (exact case)
3. the **number** of files of any type that contain `done` in **any case**

Hint: `-L`, `--include='*.txt'`.

---
Write your solution in `answer.sh`, then run `check 0622`.  
To experiment with the same test files the checker uses: `play 0622`.
