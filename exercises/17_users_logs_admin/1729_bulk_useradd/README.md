# 1729 · Creating users from a file (as root)

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** IFS=: read, id, getent, groupadd, useradd -m -c -G

This script runs **as root**. Write `altas.sh FILE`, where every line of `FILE` describes a new user:

```
login:Full Name:group1,group2
```

(the group list may be empty). Empty lines and lines starting with `#` are ignored.
For each line, in file order:

1. if a user `login` already exists (for example because an earlier line created it):
   print `skip <login>: already exists` on **stderr** and go on with the next line
2. for each group of the list (in order) that does not exist yet: create it (`groupadd`) and print
   `group <name> created`
3. create the user with a home directory, shell `/bin/bash`, the full name as comment (GECOS) and the
   listed groups as supplementary groups, and print `user <login> created`

Finally print `Created N users, skipped M`.

Exit codes: wrong number of arguments → usage on stderr, **1**; `FILE` is not a readable regular file
→ message on stderr, **2**; otherwise **3** if some line was skipped, **0** if not.

The checker compares the users and groups you create (name, GECOS, home, shell, groups, home exists)
and removes them afterwards.
