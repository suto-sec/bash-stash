# 1531 · backup_list.sh: copying the files named in a list

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** while IFS= read -r, cp, basename, continue, exit codes

Write `backup_list.sh LIST DEST`. LIST contains one path per line (relative to the current
directory; they may contain spaces). Blank lines and lines starting with `#` are ignored. Read LIST
**line by line** and, for each path, in order:

- it does not exist: print `missing: PATH` on **stderr**
- it exists but is not a regular file: print `skipped PATH (not a file)`
- a file with the **same base name** was already copied during this run:
  print `skipped PATH (duplicate name)`
- otherwise copy it into DEST (as `DEST/<basename>`, overwriting) and print `copied PATH`

If DEST does not exist, create it (with its parents) before the loop and print `created DEST`
(DEST exactly as given). Finally print `copied C, missing M, skipped S` and exit with **5** if some
path was missing, 0 otherwise.

Errors (stderr, wording free): not exactly 2 arguments → **1** (show the usage); LIST not a readable
regular file → **2** (name it); DEST exists but is not a directory → **3** (name it).
