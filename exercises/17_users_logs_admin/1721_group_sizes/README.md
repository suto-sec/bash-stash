# 1721 · Groups ranked by number of members

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** cut, tr, wc -l, sort -k

Write `groupsize.sh [group_file]` (default `/etc/group`) that prints every group that has **at least one**
supplementary member (4th field, comma-separated list, not empty) as:

```
<group> <N>
```

sorted by N **descending**, ties by group name ascending. Finally print
`Total: <G> groups, <M> memberships` (G = groups printed, M = sum of their N).

- more than one argument: usage on stderr, exit **2**
- the file is not readable: error message on stderr, exit **1**

---
Write your solution in `answer.sh`, then run `check 1721`.  
To experiment with the same test files the checker uses: `play 1721`.
