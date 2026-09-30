# 1735 · A small pwck

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** while read, tr -cd, cut, grep -qx, head -n

Write `pwcheck.sh [passwd_file] [group_file]` (defaults `/etc/passwd` and `/etc/group`) that checks
the passwd file line by line (lines numbered from 1) and reports, in this order for each line:

1. `line <n>: wrong number of fields (<f>)` if the line does not have exactly 7 `:`-separated fields
   (then **no other check** is done for that line)
2. `line <n>: duplicate login <login>` if an **earlier** line has the same login (1st field)
3. `line <n>: duplicate UID <uid> (<login>)` if an **earlier** line has the same UID (3rd field)
4. `line <n>: unknown GID <gid> (<login>)` if no line of the group file has that GID (3rd field)
   as its own 3rd field

(Only lines with 7 fields count as "earlier lines" for checks 2 and 3.) Finally print
`<P> problems in <passwd_file>`, or `<passwd_file>: OK` when there are none.

Exit codes: **0** OK, **1** some problem; more than 2 arguments → usage on stderr, **2**; a file cannot
be read → message on stderr naming it, **3**.

---
Write your solution in `answer.sh`, then run `check 1735`.  
To experiment with the same test files the checker uses: `play 1735`.
