# 1010 · Top IPs in auth.log

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** grep, grep -o, sort, uniq -c, sort -nr, head

Using the real `/var/log/auth.log`, print the **5 IP addresses** with the most
`Failed password` lines, as `uniq -c` prints them, most attempts first (ties: IP ascending as text).
