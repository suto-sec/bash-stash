# 0417 · gz_report.sh: reporting .gz files in a directory

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** find -maxdepth 1, zcat, wc -c, sort

Write `gz_report.sh`:

```
gz_report.sh DIR
```

For every `.gz` file **directly** inside `DIR` (not recursive), in alphabetical order, print:

```
name.gz: N bytes
```

where `name.gz` is the file's basename and `N` is its **uncompressed** size, obtained with
`zcat ... | wc -c`. Finally print:

```
Total: N files, B bytes
```

with the file count and the sum of their uncompressed sizes. If there are none, print
`Total: 0 files, 0 bytes` and exit 0 (this is not an error).

- Wrong number of arguments: usage on stderr, exit **1**.
- `DIR` does not exist: error naming it on stderr, exit **2**.
- `DIR` exists but is not a directory: error naming it on stderr, exit **3**.

Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0417`.  
To experiment with the same test files the checker uses: `play 0417`.
