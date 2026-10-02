# 2007 · Pull the IPs out

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** grep

`access.log` has one request per line. Print **every IPv4 address** that appears in the file, one per line, **in the order they appear** (a line may contain two of them).

Example: from `10.1.2.3 - - [...] "GET /x HTTP/1.1" 200 512 via 192.168.0.9` the output is `10.1.2.3` and `192.168.0.9`.

You need `grep` to print only the matching part of the line (not the whole line) with an extended regular expression: see `-o` and `-E` in `man grep`. Beware of other numbers with dots in the line (like `HTTP/1.1`).
