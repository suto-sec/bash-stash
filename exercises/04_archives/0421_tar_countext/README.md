# 0421 · tar_countext.sh: counting entries by extension

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** tar -tf, sort, uniq -c

Write `tar_countext.sh`:

```
tar_countext.sh ARCHIVE
```

`ARCHIVE` may be a plain `.tar` **or** a `.tgz`/`.tar.gz` — `tar -tf` (no `-z`) auto-detects the
compression, so you don't need to branch on the extension.

Count the **regular file** entries (skip directory entries, the ones `tar -tf` lists ending in
`/`) grouped by extension: the part of the entry's basename after its last `.`; files with no `.`
in their basename count as `(none)`. Print, one per line, **sorted with plain `sort`**:

```
EXT: N
```

using `.ext` for the extension (e.g. `.txt: 3`) or `(none)` for files without one, only for
extensions that actually occur. Finally print `Total: N` with the total number of regular file
entries.

- Wrong number of arguments: usage on stderr, exit **1**.
- `ARCHIVE` does not exist: error naming it on stderr, exit **2**.
- `ARCHIVE` exists but `tar -tf` fails on it: error naming it on stderr, exit **3**.

---
Write your solution in `answer.sh`, then run `check 0421`.  
To experiment with the same test files the checker uses: `play 0421`.
