# 0815 · umask only lives in its shell

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** umask, ( ), stat -c

The script runs with umask `022`. Without using `chmod`:

1. In a **subshell** (`( ... )`), set the umask to `077` and create the file `secreto.txt` and the
   directory `privado`.
2. Back in the main script (where the umask is still `022`), create `normal.txt`.
3. Set the umask so that the **group** keeps every permission and **others** get none; create
   `grupo.txt` and the directory `grupo_dir`.
4. Print the current umask (`umask`), then `stat -c '%A %n'` of `secreto.txt privado normal.txt
   grupo.txt grupo_dir` in that order.

---
Write your solution in `answer.sh`, then run `check 0815`.  
To experiment with the same test files the checker uses: `play 0815`.
