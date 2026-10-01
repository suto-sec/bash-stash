# 0836 · Quick refresher: chmod octal

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★☆☆☆☆ · **Commands:** chmod 644

In octal, each digit is a group of permissions: read = 4, write = 2, execute = 1, added up. So `6` = `rw-`, `4` = `r--`, and `644` means `rw-r--r--` (user, group, others).

The file `datos.txt` currently has the permissions `rwxrwxrwx`. Set them to `rw-r--r--` with an **octal** mode (`644`). Nothing is printed.

Afterwards `ls -l datos.txt` shows `-rw-r--r--`.

Hint: `chmod 644 file`

---
Write your solution in `answer.sh`, then run `check 0836`.  
To experiment with the same test files the checker uses: `play 0836`.
