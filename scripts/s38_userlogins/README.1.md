Lines of an authentication log look like

```
Mar 3 10:00:01 host sshd[412]: Accepted password for ana from 10.0.0.5 port 22
Mar 3 10:00:09 host sshd[413]: Failed password for luis from 10.0.0.9 port 22
```

Write `userlogins.sh LOG`. It prints `Accepted: N`, the number of lines containing `Accepted password`.
