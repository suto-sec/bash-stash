# 0422 · Packing an explicit file list

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** find, tar -T -, sort

The directory `proyecto` contains a tree of files. The file `lista.txt` has one path per line,
**relative to `proyecto`**; some of those lines point to things that do not actually exist as
regular files under `proyecto` (typos from an old list, or a directory name) — those lines must
simply be skipped, not treated as errors.

Build `filtrado.tar.gz`, a **gzip-compressed tar** containing exactly the **existing regular files**
named in `lista.txt` (and nothing else), with their paths **relative to `proyecto`** preserved
(`tar -C proyecto ...`). Then print, sorted, the archive's contents (`tar -tzf`).

Hint: filter `lista.txt` down to the paths that actually exist as regular files under `proyecto`
first, then feed that filtered list to `tar -T -` (`tar` refuses the whole archive if even one
listed path is missing).

---
Write your solution in `answer.sh`, then run `check 0422`.  
To experiment with the same test files the checker uses: `play 0422`.
