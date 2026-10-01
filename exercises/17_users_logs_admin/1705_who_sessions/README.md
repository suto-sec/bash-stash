# 1705 · Connected users

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★☆☆☆ · **Commands:** who, who -q, cut, sort, uniq

Print:

1. the number of open sessions (`who | wc -l`)
2. the names of the connected users, sorted, one per line, without repetitions
3. the users connected **remotely** (their `who` line has a host in parentheses that is **not** `:0`),
   sorted, as `user from host`
