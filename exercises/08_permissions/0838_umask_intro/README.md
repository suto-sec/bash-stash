# 0838 · Quick refresher: umask

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★☆☆☆☆ · **Commands:** umask

The `umask` removes permissions from the files you create from then on. With `umask 077` the group and the others get no permissions at all, so new files are `rw-------`.

1. Set the umask to `077`.
2. Create the empty file `secreto.txt` with `touch`.

Nothing is printed. Afterwards `ls -l secreto.txt` shows `-rw-------` (only the owner can read or write it).

Hint: the umask must be set **before** creating the file.

---
Write your solution in `answer.sh`, then run `check 0838`.  
To experiment with the same test files the checker uses: `play 0838`.
