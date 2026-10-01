# 1711 · The last IP in auth.log

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** grep -oE, tail -1

Print the **last IP address** that appears in `/var/log/auth.log` (1802 needs this), and
then on the next line the number of lines of the whole file that contain that IP.
(Beware: a dot in a regex matches anything. Use `grep -F` for the second part.)
