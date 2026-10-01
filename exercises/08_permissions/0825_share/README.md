# 0825 · share.sh (a shared group folder, as root)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** getent group, chgrp -R, chmod 2770, find -perm /111, cut, exit codes

This script is run **as root** by the checker. Write:

```
share.sh GROUP DIR
```

It prepares `DIR` to be shared by the members of `GROUP`:

1. print `Members of GROUP: <list>` with the member list of the group as `/etc/group` stores it
   (the 4th field of `getent group GROUP`, e.g. `luke,sally,rmartin`), or `(none)` if it is empty
2. the group of `DIR` and of everything inside it becomes `GROUP` (owners do not change)
3. every directory (`DIR` included) gets mode `2770` (`rwxrws---`)
4. every regular file that has **some** execute bit gets `770`; every other regular file gets `660`
5. print `Shared N directories and M files (K executable) with GROUP` (`N` includes `DIR` itself)

Errors (message on stderr), checked in this order: not exactly 2 arguments → usage, exit **1**;
`GROUP` does not exist → exit **2**, message including its name; `DIR` is not a directory → exit **3**.
Names may contain spaces. (There are no symbolic links in `DIR`.)
