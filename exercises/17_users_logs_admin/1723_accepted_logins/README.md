# 1723 · auth.log: successful SSH logins per user

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** grep, sed -E, sort -u, tail -1

Write `logins.sh [log]` (default `/var/log/auth.log`). A successful SSH login is a line like

```
Jun 20 10:00:01 labhost sshd[123]: Accepted publickey for luke from 192.168.1.10 port 5555 ssh2
```

(method `password` or `publickey`). For every user with at least one such line, sorted by user name,
print:

```
<user>: <T> logins (<P> password, <K> publickey), last from <ip>
```

where `<ip>` is the address of the **last** accepted login of that user in the file. Finally print
`Total: N accepted logins`. Lines such as `Failed password for ...` are not logins.

- more than one argument: usage on stderr, exit **2**
- the log cannot be read: error message on stderr, exit **1**
