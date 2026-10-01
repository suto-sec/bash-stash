# 1719 · Login shells in use

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** cut -d: -f7, sort, uniq -c, while read

Write `shells.sh [passwd_file]` (default `/etc/passwd`) that counts how many users (lines) have each
login shell (7th field) and prints one line per shell:

```
<shell>: <N> users
```

sorted by N **descending**, ties by shell name ascending (`sort`). Finally print:

```
Total: <U> users, <S> shells
```

(U = lines of the file, S = distinct shells). Every line of the file has 7 fields and a non-empty shell.

- more than one argument: usage on stderr, exit **2**
- the file is not a readable regular file: error message on stderr, exit **1**
