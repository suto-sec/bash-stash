# 1739 · Quick refresher: passwd -S

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★☆☆☆☆ · **Commands:** passwd -S

`passwd -S USER` prints the status of an account in a single line of fields separated by spaces, for example `alumno P 2025-09-12 0 99999 7 -1`. The first field is the login name.

Run `passwd -S` for your own user (use `$(whoami)` for the name) and print only the **first field**, by piping it into `cut`.

Expected output:

```
alumno
```

Hint: `passwd -S "$(whoami)" | cut -d' ' -f1` (`-d' '` = fields are separated by a space, `-f1` = the first field).

---
Write your solution in `answer.sh`, then run `check 1739`.  
To experiment with the same test files the checker uses: `play 1739`.
