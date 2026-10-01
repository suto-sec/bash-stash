# 0419 · chunk_pack.sh: splitting and compressing

**Topic:** tar, gzip & compression · **Difficulty:** ★★★★☆ · **Commands:** split -b -d, gzip, stat -c%s

Write `chunk_pack.sh`:

```
chunk_pack.sh FILE SIZE
```

Split `FILE` into chunks of at most `SIZE` bytes each (`split -b SIZE -d FILE DEST/part_`, where
`DEST` is `FILE.chunks`, created if needed), then compress each chunk individually with `gzip`.
Leave the original `FILE` untouched.

Then, in order (`part_00` before `part_01`, ...), print:

```
part_NN.gz: B bytes
```

where `B` is that chunk's size **before** compressing (measured with `stat -c%s`). Finally print:

```
Total: N chunks, B bytes original
```

with the chunk count and `FILE`'s total size.

- Wrong number of arguments: usage on stderr, exit **1**.
- `FILE` does not exist: error naming it on stderr, exit **2**.
- `FILE` exists but is not a regular file: error naming it on stderr, exit **3**.
- `SIZE` is not a positive integer: error on stderr, exit **4**.
