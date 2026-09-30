# 1535 · resumen_dirs.sh: looping over arguments and find results

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** for "$@", continue, find -print0, sort -z, stat

Write `resumen_dirs.sh DIR...`. For each argument, in order:

- if it is not a directory: print `not a directory: ARG` on **stderr** and continue with the next
- otherwise print

  ```
  ARG: F files, D dirs, S bytes, largest: PATH
  ```

  where F = regular files under ARG (any depth, hidden ones included), D = directories under ARG
  (ARG itself not counted), S = total size in bytes of those files, and PATH = the biggest file as
  `find ARG` prints it (the first one in `sort -z` order if tied), or `none` if there are no files

Finally print `TOTAL: N dirs, F files, S bytes` (N = valid arguments, F and S added up over them).
Exit codes: no arguments → **1** (usage on stderr); **2** if some argument was not a directory
(after processing all); 0 otherwise.

---
Write your solution in `answer.sh`, then run `check 1535`.  
To experiment with the same test files the checker uses: `play 1535`.
