# 1544 · dup_files.sh: finding byte-identical files with find + cmp

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** find -print0, sort -z, while read -r -d '', cmp -s

Write `dup_files.sh DIR`. Recursively visit every **regular file** under DIR (any depth), safely, in
`sort -z` order (`find DIR -type f -print0 | sort -z | while IFS= read -r -d '' f; do ... done`,
names may contain spaces). Keep a list of files already "kept". For each file, in that order:

- compare it (`cmp -s`) against every **previously kept** file that has the **same size**
  (`stat -c %s`), in the order they were kept; if it matches one byte-for-byte, print
  `DUP: PATH == ORIGINAL` (ORIGINAL = the matching kept file) and do **not** add it to the kept list
- otherwise add it to the kept list (print nothing)

Finally print `TOTAL: N files, K unicos, D duplicados` (N = files visited, K = files kept,
D = duplicates found).

Errors (stderr, wording free, checked in this order): not exactly 1 argument -> usage, exit **1**;
DIR does not exist -> exit **2** (name it); DIR exists but is not a directory -> exit **3** (name it).
