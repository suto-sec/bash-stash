# 1709 · auth.log: usernames attackers try

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** grep -o, sed, sort, uniq -c

From `/var/log/auth.log`, print the user names tried in `Invalid user NAME from ...` lines, with how
many times each was tried, as `uniq -c` prints it, most tried first (ties: name ascending).
