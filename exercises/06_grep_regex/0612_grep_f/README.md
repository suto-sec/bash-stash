# 0612 · Patterns from a file

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -f, grep -F

`blacklist.txt` contains IPs, one per line. `conexiones.log` contains connection lines.
Print the lines of `conexiones.log` that contain **any** of the blacklisted IPs. The IPs must be
treated as **fixed strings** (a `.` must not match any character): see `-F` and `-f`.

---
Write your solution in `answer.sh`, then run `check 0612`.  
To experiment with the same test files the checker uses: `play 0612`.
