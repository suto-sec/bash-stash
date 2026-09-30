# 0634 · sshlogins.sh (successful SSH logins)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -E, sed -E, sort -u, cut, case

Write `sshlogins.sh`:

```
sshlogins.sh LOG [METHOD]
```

`LOG` is an auth log like `/var/log/auth.log`. `METHOD` is `password`, `publickey` or `all`
(default `all` = both). A **successful login** is a line that contains

```
sshd[<digits>]: Accepted <method> for <user> from <ip> port <port>
```

with `<method>` the requested one(s) (`keyboard-interactive/pam` and anything else never count;
`Failed password` lines obviously don't either). Print every distinct pair `<user> <ip>`, one per line,
sorted (as `sort` sorts those lines), and then the summary

```
<N> logins, <P> distinct pairs, <U> users
```

(`N` = number of matching lines, `U` = distinct users). If there is no successful login, print just
`0 logins, 0 distinct pairs, 0 users` and exit **4**; otherwise exit 0.

Errors (message on **stderr**): no arguments or more than 2 → usage, exit **1**; `LOG` not
readable → exit **2**; invalid `METHOD` (exact lowercase names only) → exit **3**. Checked in that order.

---
Write your solution in `answer.sh`, then run `check 0634`.  
To experiment with the same test files the checker uses: `play 0634`.
