# 1802 · ipLog.sh (log analysis tool)

**Topic:** Exam-style scripts · **Difficulty:** ★★★★★ · **Commands:** grep -F -w, tail, find, regex validation, header info

A log analysis tool, specified precisely so it can be checked automatically:

```
ipLog.sh [<path>] [<ip>]
```

**Always first** (before any processing, even when there are errors) print this header on stdout:

```
User: <user running the script (whoami)>
Date: <date in format YYYY-MM-DD HH:MM:SS>
Bash: <$BASH_VERSION>
```

Then, depending on the arguments (the auth log is `/var/log/auth.log`; "log files" are **regular files
whose name ends in `.log`**, searched recursively under `<path>`, which may be relative or absolute):

| arguments | behaviour |
|-----------|-----------|
| none | print the last 100 lines of the auth log |
| one valid IPv4 | print `IP <ip> appears in N lines of /var/log/auth.log` |
| one directory | find the **last IP** that appears in the auth log, print `Last IP in /var/log/auth.log: <ip>`, then the log files under `<path>` that contain it (sorted, one per line, as found under `<path>`), or `No log file in <path> contains <ip>` |
| `<path> <ip>` | print every line of the log files under `<path>` containing `<ip>`, as `file:line` (files sorted by path), then `Total: N lines` |

Errors (message on **stderr**):

- more than 2 arguments → exit **1** (show usage)
- one argument that is neither a valid IP nor a directory → exit **2**
- two arguments and `<path>` is not a directory → exit **2**
- two arguments and `<ip>` is not a valid IPv4 (4 numbers 0-255) → exit **3**

An IP matches only as a whole: `1.2.3.4` must not match inside `11.2.3.45` (`grep -w -F`).
On success the exit code must be **0** (careful: a script's exit code is the one of its last command,
so a final `[ ... ] && echo ...` that evaluates to false makes the whole script "fail").

---
Write your solution in `answer.sh`, then run `check 1802`.  
To experiment with the same test files the checker uses: `play 1802`.
