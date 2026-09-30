# 0219 · Creating directories with permissions

**Topic:** Directories & navigation · **Difficulty:** ★★★☆☆ · **Commands:** mkdir -m, mkdir -p -m, stat -c

Using the `-m` option of `mkdir` (no `chmod`), create in the current directory:

1. `privado` with permissions `rwx------` (700)
2. `web/html/img` with **one** `mkdir -p -m 750` command. Notice that `-m` only applies to the
   **last** directory (`img`); `web` and `html` get the default permissions.
3. `buzon` with permissions `rwx-wx-wx` plus the **sticky bit** (1733), like `/tmp` but without
   read permission for others

Finally print, for `privado`, `web`, `web/html`, `web/html/img` and `buzon` (in this order), one line
with the permissions in `ls -l` style and the name: `stat -c '%A %n'`.

---
Write your solution in `answer.sh`, then run `check 0219`.  
To experiment with the same test files the checker uses: `play 0219`.
