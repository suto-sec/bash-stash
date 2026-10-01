# 1728 · Building an SSH blocklist

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** grep, sed, sort, uniq -c, grep -qxF, >>

Write `blocklist.sh`:

```
blocklist.sh LOG WHITELIST [THRESHOLD]
```

It counts, for every IP, the `Failed password` lines of `LOG` (the IP is the address after ` from `),
and keeps the IPs with **at least** `THRESHOLD` failures (default **5**). Those IPs are processed in
order of failures **descending**, ties by IP ascending (`sort`), and for each one:

- if it is in `WHITELIST` (a line equal to the IP): print `whitelisted <ip> (<n> failures)`
- else if it is already in the blocklist file `$HOME/blocklist.txt` (a line equal to the IP):
  print `already listed <ip>`
- else **append** it as a new line to `$HOME/blocklist.txt` (created if it doesn't exist) and print
  `blocked <ip> (<n> failures)`

Finally print `Blocked N new IPs (M already listed, K whitelisted)`.
Careful: `10.0.0.1` must not match a line `10.0.0.11`, and in a regex a `.` matches anything.

Errors (message on **stderr**, nothing is changed):

- fewer than 2 or more than 3 arguments: error and usage, exit **1**
- `LOG` cannot be read: message including its name, exit **2**
- `WHITELIST` cannot be read: message including its name, exit **3**
- `THRESHOLD` is not a positive integer: exit **4**
