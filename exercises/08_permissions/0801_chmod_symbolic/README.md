# 0801 · chmod with symbols

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★☆☆☆☆ · **Commands:** chmod u+x, o-w, ug+w, a-wx

Apply these changes with **symbolic** `chmod` (the files start with random permissions):

- `script.sh`: give the **user** execute permission
- `publico.txt`: remove **write** permission from **others**
- `equipo.txt`: give **user and group** write permission
- `bloqueado.txt`: remove write and execute from **everyone**
- `exacto.txt`: set **exactly** `rw-` for the user, `r--` for group and nothing for others, with `=`

---
Write your solution in `answer.sh`, then run `check 0801`.  
To experiment with the same test files the checker uses: `play 0801`.
