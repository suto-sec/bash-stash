# 1320 · An optional -q flag

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** shift, grep -c -F, exit codes

Write `count.sh [-q] word file...`, a tiny `grep -c`:

- For each file print `<file>: N`, N = number of lines that contain `word` (as a plain,
  case-sensitive substring), in the order of the arguments.
- If the **first** argument is `-q`, print nothing on stdout (quiet mode) but do everything else.
- A file that is not a readable regular file: print `cannot read: <file>` on stderr (also in quiet
  mode) and continue with the next one.
- Exit code: **0** if `word` appears in at least one file, **1** if it appears in none.
- Fewer than two arguments (not counting `-q`): print `Usage: count.sh [-q] word file...` on stderr
  (use `$(basename "$0")`) and exit **2**.

---
Write your solution in `answer.sh`, then run `check 1320`.  
To experiment with the same test files the checker uses: `play 1320`.
