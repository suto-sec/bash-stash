# 0820 · Where do new permissions come from?

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** umask, cp, cp -p, mkdir -m, stat -c %a

`script.sh` exists with some permissions. In this order:

1. set the umask to `077`
2. `cp script.sh copia1.sh` (a new file: the source's mode, filtered by the umask)
3. `cp -p script.sh copia2.sh` (mode preserved as it is)
4. `cat script.sh > copia3.sh` (a brand new file: `666` filtered by the umask)
5. `mkdir -m 750 d` (explicit mode: the umask is not applied)
6. `mkdir d2`
7. print `stat -c '%a %n'` of `script.sh copia1.sh copia2.sh copia3.sh d d2`

Predict each line before running it.
