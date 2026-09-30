# 0415 · pack_ext.sh: archiving files by extension

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** find, tar -cJf, stat -c%s, read

Write `pack_ext.sh`:

```
pack_ext.sh SRCDIR EXT OUTFILE
```

It finds every **regular file** under `SRCDIR` (recursively) whose name ends in `.EXT` (`EXT` is
given without a leading dot, e.g. `log`), and packs them into `OUTFILE`, an **xz-compressed tar**
(`tar -cJf`), keeping their paths **relative to `SRCDIR`** (run tar with `-C SRCDIR`).

Then print exactly:

```
Packed N files (B bytes) into OUTFILE
```

where `N` is the number of files packed and `B` is the sum of their sizes in bytes (measured
**before** packing, with `stat -c%s`).

- Wrong number of arguments: usage on stderr, exit **1**.
- `SRCDIR` does not exist: error naming it on stderr, exit **2**.
- `SRCDIR` exists but is not a directory: error naming it on stderr, exit **3**.
- No file under `SRCDIR` ends in `.EXT`: error on stderr, exit **4**, and `OUTFILE` must not be
  created.

Error messages go to stderr (wording is free). Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0415`.  
To experiment with the same test files the checker uses: `play 0415`.
