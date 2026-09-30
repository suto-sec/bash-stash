# 1731 · Auditing home directories

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** while IFS=: read, test -e -d, stat -c %a, find -perm

Write `homes.sh [passwd_file]` (default `/etc/passwd`) that checks the home directory (6th field) of
every **human** user (UID from 1000 to 59999), in file order, and prints one line per problem:

- the home doesn't exist: `<login>: <home> missing`
- it exists but is not a directory: `<login>: <home> is not a directory`
- it is a directory that gives **any** permission (r, w or x) to **others**:
  `<login>: <home> is open to others (<perms>)`, where `<perms>` is the octal mode as `stat -c %a`
  prints it (e.g. `755`)

Homes without problems print nothing. Finally print `Checked N users, P problems`.

Exit codes: **0** if there were no problems, **1** if there was some; more than one argument → usage on
stderr, **2**; the file cannot be read → message on stderr, **3**. Paths may contain spaces.

---
Write your solution in `answer.sh`, then run `check 1731`.  
To experiment with the same test files the checker uses: `play 1731`.
