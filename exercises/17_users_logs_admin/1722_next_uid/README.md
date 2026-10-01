# 1722 · The next free UID

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** cut, grep -qx, while, $(( ))

`useradd` picks the first free UID from 1000 on. Write `nextuid.sh [passwd_file] [MIN]` (defaults
`/etc/passwd` and `1000`) that prints:

```
Next free UID: <U>
UIDs in use >= <MIN>: <N>
```

- U = the **smallest** number `>= MIN` that is not the UID (3rd field) of any line of the file
  (the file is not sorted, and UIDs may have gaps)
- N = number of lines whose UID is `>= MIN`

Errors (message on stderr):

- the file cannot be read: exit **1**
- `MIN` is not a non-negative integer (digits only): exit **2**
- more than two arguments: usage, exit **3**
