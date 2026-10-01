# 0416 · unpack_safe.sh: rejecting path traversal

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** tar -tzf, tar -xzf -C, mkdir -p, case

Write `unpack_safe.sh`:

```
unpack_safe.sh ARCHIVE DEST
```

`ARCHIVE` must be a `.tgz`. Before extracting anything, list its entries (`tar -tzf`) and check
that **none** of them would escape `DEST`: reject any entry whose path is absolute (starts with
`/`) or contains a `..` component.

- If any such entry exists: print to stderr `Unsafe path in archive: <path>` (the first offending
  path, in the order `tar -tzf` lists them) and exit **4**. Do not create `DEST` and do not
  extract anything.
- Otherwise: if `DEST` does not exist, create it and print `Directory DEST created` (using the
  `DEST` argument exactly as given). Then extract the whole archive into `DEST`
  (`tar -xzf ARCHIVE -C DEST`) and print `Extracted N entries into DEST`, where `N` is the result
  of `tar -tzf ARCHIVE | wc -l`.

Other errors:
- Wrong number of arguments: usage on stderr, exit **1**.
- `ARCHIVE` does not exist: error naming it on stderr, exit **2**.
- `ARCHIVE` exists but `tar -tzf` fails on it: error naming it on stderr, exit **3**.

Names may contain spaces.
