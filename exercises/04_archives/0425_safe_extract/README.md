# 0425 · safe_extract.sh: refusing to extract a bomb

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** tar -tvzf, tar -xzf -C, exit codes

Write `safe_extract.sh`:

```
safe_extract.sh ARCHIVE DEST MAXBYTES
```

Before extracting anything, compute the total **uncompressed** size of every regular-file entry in
`ARCHIVE` (a `.tar.gz`), using the size column of `tar -tvzf` (directory entries, whose mode starts
with `d`, do not count). If that total is **greater than** `MAXBYTES`, refuse: print to stderr
`Refused: N bytes exceed the MAXBYTES bytes limit` (with `N` = the total and `MAXBYTES` the argument,
substituted literally), exit **4**, and do not create `DEST` or extract anything.

Otherwise: create `DEST` if it does not exist (with parents) and extract the whole archive into it
(`tar -xzf ARCHIVE -C DEST`); then print `Extracted N entries (B bytes) into DEST`, where `N` is the
total number of entries `tar -tzf` lists (directories included) and `B` is the total computed above.

Other errors (message on stderr): not exactly 3 arguments → usage, exit **1**; `ARCHIVE` does not
exist or `tar -tzf` fails on it → exit **2** (message includes `ARCHIVE`); `MAXBYTES` is not a
non-negative integer → exit **3** (message includes `MAXBYTES`).
