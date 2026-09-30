# 0326 · dedup.sh (hard-linking duplicates)

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** cmp -s, ln -f, test -ef -L -s, stat -c %s

Write `dedup.sh DIR` that saves space by replacing duplicate files with **hard links**.

Consider the **regular, non-empty** files directly inside `DIR` (symbolic links, directories and empty
files are ignored), in the order of the `DIR/*` glob. For each file `F`, look for the **first earlier**
file (in that order) with exactly the same content (`cmp`):

- if `F` is **already** a hard link to it (same inode, `test -ef`), do nothing
- otherwise replace `F` by a hard link to that earlier file (`ln -f`) and print `NAME => FIRST`
  (both names without the directory)

Finally print `Linked N files, saved B bytes`, where `B` is the sum of the sizes of the replaced files.
Names may contain spaces.

Errors (message on stderr): not exactly one argument → usage, exit **1**; `DIR` is not a directory →
exit **2**, with a message including `DIR`.

---
Write your solution in `answer.sh`, then run `check 0326`.  
To experiment with the same test files the checker uses: `play 0326`.
