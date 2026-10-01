# 1703 · The fields of /etc/passwd

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★☆☆☆ · **Commands:** cut, while IFS=: read

For every **human** user of the real `/etc/passwd` (UID between 1000 and 59999), print:

```
login | uid | full name (GECOS field up to the first comma) | home | shell
```

in file order. Example: `jgarcia | 1004 | Juan Garcia | /home/jgarcia | /bin/bash`.
