# 1814 · Brute-force detector

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** grep, grep -oE, sort, uniq -c, while read

Write `bruteforce.sh [LOG] [THRESHOLD]` (defaults `/var/log/auth.log` and `10`) that prints every IP
with **at least** THRESHOLD `Failed password` lines in LOG, as `<ip> <count>`, sorted by count
descending and then by IP (as text). If none reaches the threshold, print `No suspicious IPs` and
exit **1**.

- more than 2 arguments: usage on stderr, exit 4
- LOG not readable: stderr, exit 2
- THRESHOLD not a positive integer: stderr, exit 3

---
Write your solution in `answer.sh`, then run `check 1814`.  
To experiment with the same test files the checker uses: `play 1814`.
