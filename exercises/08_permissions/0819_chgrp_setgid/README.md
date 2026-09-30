# 0819 · Groups without root, and setgid directories

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** chgrp, chgrp -R, find -type d, chmod g+s, stat -c %G

You don't need root to change the group of **your** files to a group **you belong to**
(`id -Gn`). The user running the script (`alumno`) belongs to `adm` and `secops`.

1. Change the group of every `*.log` file in `logs` to `adm`.
2. Change the group of the directory `equipo` and everything inside it to `secops`.
3. Set the **setgid** bit on `equipo` and on every directory below it (only directories).
4. Create the files `equipo/nuevo.txt` and `equipo/sub/otro.txt`.
5. Print `stat -c '%G %n'` of those two new files. Thanks to setgid they belong to `secops`.

---
Write your solution in `answer.sh`, then run `check 0819`.  
To experiment with the same test files the checker uses: `play 0819`.
