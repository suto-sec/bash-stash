# 0556 · logmonth.sh: chronological order with sort -M

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** sort -k M, -k n, script argument

Write `logmonth.sh`:

```
logmonth.sh FILE [N]
```

`FILE` has syslog-style lines `MON DD HH:MM:SS resto...` (`MON` a 3-letter month abbreviation,
`DD` a zero-padded day). Print the lines sorted **chronologically within the year**: by month
(`Jan` before `Feb` before ... before `Dec` — this is what `sort`'s `M` key type does), then by day
as a number, then by time; ties broken the way `sort` breaks them by default (comparing the rest of
the line). If `N` is given, print only the first `N` lines of that order.

Errors (message on **stderr**, nothing on stdout):

- not 1 or 2 arguments: error and usage, exit **1**
- `FILE` is not a readable regular file: message with its name, exit **2**
- `N` is not a positive integer: message with it, exit **3**

---
Write your solution in `answer.sh`, then run `check 0556`.  
To experiment with the same test files the checker uses: `play 0556`.
