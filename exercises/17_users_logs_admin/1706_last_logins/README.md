# 1706 · Login history with last

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** last, grep, sort, uniq -c

Using `last` (it reads `/var/log/wtmp`), print:

1. the number of sessions recorded for each user, in `uniq -c` format sorted by user name
   (ignore the empty line and the `wtmp begins` line)
2. `---`
3. the lines of sessions that have an **end time and duration** (they contain `(hh:mm)`)

---
Write your solution in `answer.sh`, then run `check 1706`.  
To experiment with the same test files the checker uses: `play 1706`.
