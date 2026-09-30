# 1720 · Shells not listed in /etc/shells

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** while IFS=: read, grep -qxF, case

Write `badshell.sh [passwd_file] [shells_file]` (defaults `/etc/passwd` and `/etc/shells`) that prints,
in the order of the passwd file, every user whose login shell is **not** a valid shell, as:

```
<login>: <shell>
```

A shell is valid when some line of the shells file is **exactly** that path (lines starting with `#`
are comments and never match). Accounts that are disabled on purpose are **not** reported: those
whose shell ends in `/nologin` or `/false`.

Finally print `N users with an invalid shell`.

- more than two arguments: usage on stderr, exit **2**
- one of the files cannot be read: error message on stderr naming it, exit **1**

(On the lab system, `pruiz` has `/bin/dash`, but `/etc/shells` only lists `/usr/bin/dash`.)

---
Write your solution in `answer.sh`, then run `check 1720`.  
To experiment with the same test files the checker uses: `play 1720`.
