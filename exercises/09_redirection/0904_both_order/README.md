# 0904 · 2>&1 and the order of redirections

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★☆☆☆ · **Commands:** 2>&1, &>

The script `ruidoso.sh` writes to stdout and stderr. Run it so that:

1. **both** streams go to `todo.log` (in the order they were produced)
2. then run it again with `./ruidoso.sh 2>&1 > solo_out.log`: stderr goes to the **screen** (your
   stdout!) and only stdout to the file. Understand why.

The checker compares your stdout and the files.
