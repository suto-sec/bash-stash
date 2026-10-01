# 0805 · umask: default permissions

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★☆☆☆ · **Commands:** umask

1. Print the current umask (the checker runs your script with umask `0022`).
2. Change the umask so that new **files** are created `rw-r-----` and new **directories** `rwxr-x---`.
3. Create the file `nuevo.txt` and the directory `nuevodir`.
4. Print the new umask.

Do not use `chmod` in this exercise.
