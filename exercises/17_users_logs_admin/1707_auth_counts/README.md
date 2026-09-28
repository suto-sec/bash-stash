# 1707 · auth.log: counting events

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★☆☆☆ · **Commands:** grep -c, /var/log/auth.log

From the real `/var/log/auth.log` (you can read it because you're in group `adm`), print:

```
failed passwords: N
invalid users: N
accepted logins: N
sudo commands: N
telnet connections: N
```

- failed passwords: lines with `Failed password`
- invalid users: lines with `Invalid user`
- accepted logins: lines with `Accepted `
- sudo commands: lines with `COMMAND=`
- telnet connections: lines from `in.telnetd`

---
Write your solution in `answer.sh`, then run `check 1707`.  
To experiment with the same test files the checker uses: `play 1707`.
