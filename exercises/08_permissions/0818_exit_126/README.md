# 0818 · Permission denied: exit codes 126 and 127

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★☆☆ · **Commands:** chmod u+x, $?, bash script.sh

The script `hola.sh` has no execute permission, and the directory `cerrado` has mode `600` (no `x`).
Run these steps, hiding error messages with `2>/dev/null` where it says so:

1. run `./hola.sh` (hide errors) and print `exit: N` with its exit code
2. run it as `bash hola.sh` (it works: reading is enough for `bash`)
3. run `./nada.sh`, which does not exist (hide errors), and print `exit: N`
4. give the owner execute permission on `hola.sh` and run `./hola.sh` again
5. `cat cerrado/dato` (hide errors) and print `exit: N`
6. give the owner execute permission on `cerrado` and `cat cerrado/dato` again

Notice the codes: **126** = found but cannot be executed, **127** = command not found.
