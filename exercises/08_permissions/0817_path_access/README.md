# 0817 · Sharing one folder of a private tree

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** chmod -R go=, g+x, g+r, stat -c %A

To read a file you need `r` on the file **and** `x` on every directory of its path (not `r`: `r` on
a directory only lets you list it).

1. Remove **every** permission of group and others from `privado` and everything below it.
2. Let the **group** read the files `privado/compartir/*.txt` (and nothing else): give the group `r`
   on those files and **only** `x` on the directories `privado` and `privado/compartir`.
3. Print `stat -c '%A %n'` of `privado`, `privado/compartir` and then the `privado/compartir/*.txt` files
   (glob order).
