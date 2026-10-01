# 1724 · Apache access.log: requests and bytes per status

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** cut -d' ' -f9,10, sort -u, while read, $(( ))

Write `httpcodes.sh [access_log]` (default `/var/log/apache2/access.log`). Each line of the log looks like

```
192.168.1.10 - - [20/Jun/2026:09:02:13 +0200] "GET /images/logo.png HTTP/1.1" 403 614
```

so the status code is the **9th** space-separated field and the response size in bytes the **10th**
(`-` means 0 bytes). Print one line per status code, sorted by code ascending:

```
<code> <requests> <bytes>
```

and finally `total <requests> <bytes>`.

- more than one argument: usage on stderr, exit **2**
- the log cannot be read: error message on stderr, exit **1**
