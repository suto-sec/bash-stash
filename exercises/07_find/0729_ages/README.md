# 0729 · ages.sh: recently modified files

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -mtime -N, stat -c %Y, date +%s, arithmetic

Write `ages.sh`:

```
ages.sh DIR [DAYS]
```

(`DAYS` defaults to 7). It lists the **regular files** under `DIR` (recursively) modified **less than
DAYS days ago**, i.e. whose **age** is smaller than DAYS, where

```
age = (now - modification time) / 86400      (integer division, times in seconds:
                                               now = date +%s, mtime = stat -c %Y)
```

(this is exactly what `find -mtime -DAYS` selects). Print one line per file:

```
<age> <path>
```

sorted by age (ascending) and then by path; path as `find` prints it. Finally print
`N recent files, M older` where M is the number of the **other** regular files under `DIR`.
Symbolic links and directories are never counted.

Checks, **in this order** (messages on stderr, wording free):

- no arguments or more than 2: usage, exit **1**
- `DIR` is not a directory: exit **2**
- `DAYS` is not a positive integer (≥ 1): exit **3**

Names may contain spaces.
