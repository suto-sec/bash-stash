# 1321 · The last argument is the destination

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** ${!#}, ${@:1:$#-1}, cp

Write `collect.sh file... dir`, which works like `cp file... dir`: the **last** argument is the
destination directory and all the others are files to copy into it.

- Fewer than 2 arguments: `Usage: collect.sh file... dir` on stderr (use `$(basename "$0")`), exit **1**.
- The last argument is not a directory: `Not a directory: <dir>` on stderr, exit **2** (copy nothing).
- For each file (in order): if it is a regular file, copy it into the directory and print
  `copied: <file>`; otherwise print `skipped: <file>` on **stderr**.
- Finally print `N copied, M skipped`, and exit **0** if nothing was skipped or **3** otherwise.

Use `${!#}` (or `${@: -1}`) for the last argument and `${@:1:$#-1}` for the rest.

---
Write your solution in `answer.sh`, then run `check 1321`.  
To experiment with the same test files the checker uses: `play 1321`.
