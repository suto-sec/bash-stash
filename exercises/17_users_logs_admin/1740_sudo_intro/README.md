# 1740 · Quick refresher: sudo -u

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★☆☆☆☆ · **Commands:** sudo -u

`sudo -u USER command` runs a command as another user.

Run `whoami` **as the user `luke`** and print what it says (`whoami` prints the name of the user that runs it).

Expected output:

```
luke
```

Hint: `sudo -u luke whoami`

---
Write your solution in `answer.sh`, then run `check 1740`.  
To experiment with the same test files the checker uses: `play 1740`.
