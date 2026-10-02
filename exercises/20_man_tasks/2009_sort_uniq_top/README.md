# 2009 · The three busiest IPs

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** sort, uniq, head

`ips.txt` has one IP address per line; some appear many times. Print the **three most frequent** ones, each preceded by the number of times it appears (the way `uniq -c` writes it), most frequent first. All counts are different.

Example: `      5 10.0.0.1` on the first line.

It is the classic pipeline of the log-analysis practical: `sort`, `uniq -c`, then another `sort` (which option makes it numeric and descending?) and `head`. Check `man uniq` and `man sort`.
