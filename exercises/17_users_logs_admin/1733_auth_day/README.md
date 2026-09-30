# 1733 · auth.log: summary of one day

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** grep -E, tr -s, cut, sort -u, head, tail

Write `dia.sh DAY [LOG]` (LOG defaults to `/var/log/auth.log`) that summarises the lines of `LOG`
whose day of the month is `DAY`. Syslog pads single-digit days with a space (`Jun  8`), so the day is
the **2nd field once blanks are squeezed**; `1` must not select day `11`. Print exactly:

```
lines: <L>
failed: <F>
accepted: <A>
sudo: <S>
attackers: <K>
first: <HH:MM:SS>
last: <HH:MM:SS>
```

- failed: lines of that day containing `Failed password`; accepted: containing `Accepted `;
  sudo: containing `COMMAND=`
- attackers: number of **distinct** IPs (the address after ` from `) in that day's failed lines
- first/last: time (3rd field) of the first and last line of that day

Errors (message on **stderr**):

- no arguments or more than 2: usage, exit **1**
- `DAY` is not a number from 1 to 31 written without leading zeros: exit **2**
- `LOG` cannot be read: exit **3**
- no line of that day: message `no entries for day <DAY>`, exit **4**

---
Write your solution in `answer.sh`, then run `check 1733`.  
To experiment with the same test files the checker uses: `play 1733`.
