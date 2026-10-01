# 0420 · xz_best.sh: keeping the smaller of gzip/xz

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** gzip -9, xz -9, stat -c%s

Write `xz_best.sh`:

```
xz_best.sh DIR
```

For every **regular file** directly inside `DIR` (not recursive), compress it with both
`gzip -9` and `xz -9`, keep only whichever result is **smaller** (delete the other, and delete the
original), and rename the survivor to `name.gz` or `name.xz`. **On a tie, keep the `gzip` result.**

**Important:** `gzip` stores the original file's name inside the compressed header, which changes
the compressed size by a few bytes depending on the name's length — so always run `gzip -9`
directly on the file itself (e.g. `gzip -9 -k FILE`, which keeps the original), never on a renamed
copy of it. `xz` has no such issue (its output size never depends on the input's filename), so for
the `xz` candidate you may freely compress a temporary copy (you need one anyway, to still have an
uncompressed original left in case `gzip` wins).

Then, sorted by original name, print:

```
name: kept EXT (B bytes, saved P%)
```

where `EXT` is `gz` or `xz`, `B` is the kept file's size, and `P` is
`(original_bytes - B) * 100 / original_bytes` computed with **integer** arithmetic (truncated,
no decimals). Finally print:

```
Total: N files, S bytes saved
```

with the file count and the total bytes saved (`sum(original_bytes - B)`). If `DIR` has no
regular files directly inside it, print `Total: 0 files, 0 bytes saved` (not an error).

- Wrong number of arguments: usage on stderr, exit **1**.
- `DIR` does not exist: error naming it on stderr, exit **2**.
- `DIR` exists but is not a directory: error naming it on stderr, exit **3**.

Names may contain spaces.
