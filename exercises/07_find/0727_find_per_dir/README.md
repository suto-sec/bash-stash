# 0727 · Counting files per directory

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find, sed, sort, uniq -c, while read

Under `logs`, count the regular files ending in `.log` **per directory** (the directory that
contains them directly). Print one line per directory that has at least one, as

```
<directory>: <N>
```

sorted by N (descending) and then by directory (alphabetical). Directories are written as find
prints them (e.g. `logs/web server`). Other files (`.txt`, `.log.1`...) don't count.

---
Write your solution in `answer.sh`, then run `check 0727`.  
To experiment with the same test files the checker uses: `play 0727`.
