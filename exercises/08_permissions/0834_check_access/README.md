# 0834 · check_access.sh: asking the kernel, not computing it yourself

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** sudo -u, test -r -w -x, id, exit codes

This script runs **as root**. A tempting shortcut to check whether some other user could read a file
is `[ -r FILE ]` — but that is **wrong** when your script runs as root: the `test`/`[` builtin, like
every other program, asks the kernel "can **the process running me** do this?", and root always gets
"yes", regardless of the file's permissions. Write `check_access.sh`:

```
check_access.sh USER FILE
```

Determine, for real, whether `USER` (not root, not you) could read, write and execute/enter `FILE`,
by asking the kernel to check it **as that user**: run the test itself under
`sudo -u USER -- test -r FILE` (and `-w`, `-x`) instead of computing it from `stat` and group
membership yourself. Print exactly:

```
read:yes|no write:yes|no exec:yes|no
```

Errors (message on stderr): not exactly 2 arguments → usage, exit **1**; `USER` does not exist →
exit **2** (message includes `USER`); `FILE` does not exist → exit **3** (message includes `FILE`).
