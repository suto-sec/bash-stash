# 1710 · auth.log: what was run with sudo

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** grep, sed / cut, sort, uniq -c

Print the commands executed with `sudo` (the text after `COMMAND=`) with how many times each one was
run, as `uniq -c` prints it, sorted by count descending and then by command.

---
Write your solution in `answer.sh`, then run `check 1710`.  
To experiment with the same test files the checker uses: `play 1710`.
