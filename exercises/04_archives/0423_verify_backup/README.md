# 0423 · verify_backup.sh: diffing a directory against a .tar.gz

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** tar -tzf, tar -xOzf, cmp -s, sort, exit codes

Write `verify_backup.sh`:

```
verify_backup.sh DIR ARCHIVE
```

Without extracting anything to disk, check whether `ARCHIVE` (a `.tar.gz`) is an up-to-date backup
of `DIR`. Consider the **regular files** under `DIR` (recursively) by their path relative to `DIR`,
and the **non-directory entries** of `ARCHIVE` by their path as `tar -tzf` prints it (entries ending
in `/` are directories: ignore them). For every relative path that appears in either side, in sorted
order, print:

- `missing REL` if `DIR` has it but `ARCHIVE` does not
- `extra REL` if `ARCHIVE` has it but `DIR` does not
- `changed REL` if both have it but the content differs (compare `DIR/REL` against
  `tar -xOzf ARCHIVE REL`, which streams that one member to stdout without touching disk)
- nothing if both have it with identical content

Finally print `Differences: N`. Exit **1** if `N` is greater than 0, **0** if it is 0.

Other errors (message on stderr): not exactly 2 arguments → usage, exit **2**; `DIR` is not a
directory → exit **3** (message includes `DIR`); `ARCHIVE` does not exist or `tar -tzf` fails on it
→ exit **4** (message includes `ARCHIVE`).

---
Write your solution in `answer.sh`, then run `check 0423`.  
To experiment with the same test files the checker uses: `play 0423`.
