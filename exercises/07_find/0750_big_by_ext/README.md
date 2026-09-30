# 0750 · big_by_ext.sh: large files grouped by extension

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -size +Nk, sed, sort, uniq -c, script argument

Write `big_by_ext.sh`:

```
big_by_ext.sh [directory]
```

Under `directory` (default: the current directory), among the **regular files larger than 100 KiB**
(`-size +100k`), count them **grouped by extension** (the part of the name after the last `.`;
files without a dot are ignored). Print exactly what `uniq -c` produces, **sorted by count
descending, then by extension ascending** (same convention as exercise 0716), one group per line.
Then print exactly:

```
Total: N files
```

where `N` is the number of big files counted (the sum over all groups, not the number of groups).

---
Write your solution in `answer.sh`, then run `check 0750`.  
To experiment with the same test files the checker uses: `play 0750`.
