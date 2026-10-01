# 0755 · Quick refresher: find -mtime

**Topic:** find · **Difficulty:** ★☆☆☆☆ · **Commands:** find -mtime

`-mtime +5` selects files modified **more than 5 days ago**.

Under the directory `logs`, print the regular files modified more than 5 days ago, in alphabetical order, one per line (pipe the result of `find` into `sort`).

Example: if only `f1.log` and `f4.log` are older than 5 days, the output is:

```
logs/f1.log
logs/f4.log
```

Hint: `find dir -type f -mtime +5 | sort`
