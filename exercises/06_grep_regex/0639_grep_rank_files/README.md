# 0639 · Ranking files by how often a word appears

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -ci, sort -k (numeric + text), cat

Under `logs/` there are several files (no subdirectories). For every file that contains **at least
one** line with the word `timeout` in **any** letter case, print:

```
<count> <path>
```

(`count` = number of matching **lines** in that file, `path` exactly as `logs/name`), **sorted by
count descending, then by path ascending**. Files with zero matches are not listed individually.
Finally print:

```
Total: N
```

where `N` is the number of matching lines summed over **every** file in `logs/` (including the ones
with zero, which contribute nothing).

---
Write your solution in `answer.sh`, then run `check 0639`.  
To experiment with the same test files the checker uses: `play 0639`.
