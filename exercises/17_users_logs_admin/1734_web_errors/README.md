# 1734 · Apache: paths with most errors

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** cut, sort, uniq -c, head, $(( ))

Write `weberrors.sh [LOG] [N]` (defaults `/var/log/apache2/access.log` and `5`). In an access log line

```
192.168.1.10 - - [20/Jun/2026:09:02:13 +0200] "GET /images/logo.png HTTP/1.1" 403 614
```

the client IP is the 1st space-separated field, the path the 7th and the status code the 9th.
An **error** is a request with status `>= 400`. Print the `N` paths with most errors as

```
<errors> <path> (<k> IPs)
```

(k = number of **distinct** client IPs among that path's error requests), ordered by errors descending,
ties by path ascending; then the line `Errors: <E> of <R> requests (<P>%)`, P = E·100/R with integer
division. With no errors, only that last line is printed.

Errors (message on **stderr**):

- more than 2 arguments: usage, exit **1**
- `LOG` cannot be read: exit **2**
- `N` is not a positive integer: exit **3**
- `LOG` has no lines: exit **4**

---
Write your solution in `answer.sh`, then run `check 1734`.  
To experiment with the same test files the checker uses: `play 1734`.
