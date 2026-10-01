# 0753 · Quick refresher: find -type

**Topic:** find · **Difficulty:** ★☆☆☆☆ · **Commands:** find -type f, -type d

`find -type d` selects only directories; `-type f` selects only regular files.

Under the directory `tree`, print only the **directories** (not the files), including `tree` itself, in alphabetical order, one per line (pipe the result of `find` into `sort`).

Expected output:

```
tree
tree/a
tree/b
tree/b/c
```

Hint: `find dir -type d | sort`

---
Write your solution in `answer.sh`, then run `check 0753`.  
To experiment with the same test files the checker uses: `play 0753`.
