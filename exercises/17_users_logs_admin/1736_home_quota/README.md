# 1736 · Home directories over a quota

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** du -sk, cut -f1, test -r -x, while IFS=: read

Write `cuota.sh LIMIT_KB [passwd_file]` (default `/etc/passwd`). For every human user (UID from 1000
to 59999) in file order, look at their home directory (6th field):

- it doesn't exist or is not a directory: print `<login>: no home (<home>)`
- you can't read it (no `r` **or** no `x` permission for you): print `<login>: cannot read <home>`
- otherwise measure it with `du -sk` and, **only if** it uses more than `LIMIT_KB` KB, print
  `<login>: <KB> KB (over by <KB-LIMIT_KB> KB)`

Finally print `<N> users over the limit of <LIMIT_KB> KB`.

Errors (message on **stderr**):

- no arguments or more than 2: usage, exit **1**
- `LIMIT_KB` is not a positive integer: exit **2**
- the passwd file cannot be read: exit **3**

Home paths may contain spaces.
