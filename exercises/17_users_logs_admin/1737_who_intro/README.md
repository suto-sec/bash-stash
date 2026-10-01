# 1737 · Quick refresher: who

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★☆☆☆☆ · **Commands:** who

`who` lists the users who are logged in right now, one per line.

Print how many sessions are open: pipe `who` into `wc -l` and print only the number.

Example: with two people logged in, it prints `2`. The number depends on who is logged in at that moment, so it is not the same on every machine: the checker compares your answer with the reference in the same environment.

Hint: `who | wc -l`
