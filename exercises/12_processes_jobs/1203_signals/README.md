# 1203 · Signal names and numbers

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** kill -l

Using `kill -l`, print (one per line):

1. the number of the signal `TERM`
2. the number of the signal `KILL`
3. the number of `INT` (what Ctrl+C sends)
4. the number of `TSTP` (what Ctrl+Z sends)
5. the name of signal number `1`
6. the name of the signal a process died from if its exit status was `137` (`kill -l 137`)
