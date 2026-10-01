# 0754 · Quick refresher: find -size

**Topic:** find · **Difficulty:** ★☆☆☆☆ · **Commands:** find -size

`-size +1M` selects files bigger than 1 MiB (`M` = megabytes; `k` = kilobytes, `c` = bytes).

Under the directory `files`, print the **regular files** bigger than 1 MiB, in alphabetical order, one per line (pipe the result of `find` into `sort`).

Example: if only `f2` and `f4` are bigger than 1 MiB, the output is:

```
files/f2
files/f4
```

Hint: `find dir -type f -size +1M | sort`

---
Write your solution in `answer.sh`, then run `check 0754`.  
To experiment with the same test files the checker uses: `play 0754`.
