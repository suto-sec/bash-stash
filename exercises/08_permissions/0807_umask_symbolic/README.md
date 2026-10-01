# 0807 · Symbolic umask

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★☆☆☆ · **Commands:** umask -S, umask u=,g=,o=

1. Using a **symbolic** umask, allow everything to the user, only read+execute to the group and
   nothing to others (`umask u=rwx,g=rx,o=`).
2. Print the umask in symbolic form (`umask -S`) and in octal form (`umask`).
3. Create the directory `privado` and the file `privado/nota`.
