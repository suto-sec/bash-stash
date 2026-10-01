# 0918 · Logging the rest of a script with exec

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★☆☆ · **Commands:** exec 3>&1, exec > file 2>&1, exec 1>&3 3>&-

Write a script that:

1. prints `starting` on the screen
2. saves the current stdout and stderr in file descriptors 3 and 4 (`exec 3>&1 4>&2`) and then
   redirects **both** stdout and stderr of the rest of the script to `script.log` (one `exec`)
3. runs, in this order: `echo "== files =="`, `ls datos`, `ls noexiste` (it fails: its error message
   must end up in the log), `echo "== end =="`
4. restores stdout and stderr from fds 3 and 4 and closes them (`exec 1>&3 2>&4 3>&- 4>&-`)
5. prints on the screen `logged <N> lines`, where N is the number of lines of `script.log`

Nothing but `starting` and `logged <N> lines` may appear on your stdout, and nothing on your stderr.
