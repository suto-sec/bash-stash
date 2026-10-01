# 1708 · auth.log: attempts per day

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** cut -c, tr -s, uniq -c

Print the number of `Failed password` lines **per day** of `/var/log/auth.log`, in chronological
order, as:

```
Jun 8: 57
Jun 9: 61
...
Jun 20: 70
```

Careful: syslog pads single-digit days with a space (`Jun  8`), so a naive `cut -d' ' -f1,2` breaks.
