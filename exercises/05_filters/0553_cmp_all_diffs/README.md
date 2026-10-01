# 0553 · Every differing byte with cmp -l

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** cmp -l, wc -l

`orig.bin` and `mod.bin` are two files of the **same size** that differ in one or more bytes.
Print every byte position where they differ, exactly as `cmp -l` prints it (position, then each
file's byte value in octal, one differing byte per line). Then print:

```
Total: N bytes differ
```
