# 0810 · chown and chgrp (as root)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** sudo chown, chgrp, chown -R

This script is run **as root** by the checker (in real life, use `sudo`). In the current directory:

1. make `luke` the owner of `informe.txt`
2. make user `sally` and group `devs` the owner/group of `datos.csv` (one command, `user:group`)
3. change **only the group** of `publico` to `adm`
4. recursively give the directory `proyecto` to `jgarcia` with group `secops`

---
Write your solution in `answer.sh`, then run `check 0810`.  
To experiment with the same test files the checker uses: `play 0810`.
