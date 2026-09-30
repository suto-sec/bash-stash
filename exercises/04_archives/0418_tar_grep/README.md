# 0418 · tar_grep.sh: searching inside a .tgz

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** tar -tzf, tar -xOzf, grep -qF

Write `tar_grep.sh`:

```
tar_grep.sh ARCHIVE PATTERN
```

`ARCHIVE` is a `.tgz`. Without leaving any extracted file behind, print the path of every
**regular file** entry whose content contains `PATTERN` (a literal substring, not a regex — use
`grep -F`), one per line, sorted, followed by:

```
Matches: N
```

If nothing matches, print only `Matches: 0`.

- Wrong number of arguments: usage on stderr, exit **1**.
- `ARCHIVE` does not exist: error naming it on stderr, exit **2**.
- `ARCHIVE` exists but `tar -tzf` fails on it: error naming it on stderr, exit **3**.

Hint: `tar -xOzf ARCHIVE MEMBER` streams a single member's content to stdout without touching
disk. Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0418`.  
To experiment with the same test files the checker uses: `play 0418`.
