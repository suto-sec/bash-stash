# 0835 · Quick refresher: chmod symbolic

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★☆☆☆☆ · **Commands:** chmod u+x

Permissions come in three groups: the **u**ser (owner), the **g**roup and **o**thers. `chmod u+x file` **adds** (`+`) the **x** (execute) permission to the user's group; `-` removes one.

The file `script.sh` currently has the permissions `rw-r--r--`. Add execute permission for the user with **symbolic** `chmod` (`u+x`, not numbers). Nothing is printed.

Afterwards `ls -l script.sh` shows `-rwxr--r--`.

Hint: `chmod u+x file`
