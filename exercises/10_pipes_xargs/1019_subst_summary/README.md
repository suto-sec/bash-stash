# 1019 · A one-line summary

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** $( ), find, wc, xargs

Print **one line** that summarises the directory `proj`, building it with command substitution
(`echo "... $(...) ..."`):

```
proj: F files, D directories, B bytes, largest: P
```

- `F`: number of regular files under `proj` (recursively)
- `D`: number of directories under `proj` (recursively, **not** counting `proj` itself)
- `B`: total size in bytes of those regular files (the sum of their sizes)
- `P`: path of the biggest regular file, as `find proj` prints it (there are no ties)

Names may contain spaces.
