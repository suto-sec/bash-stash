# 0411 · Creating and listing a .tar.bz2

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** tar -cjf, tar -tjf, sort

Create a bzip2-compressed archive `entrega.tar.bz2` containing everything under the directory
`trabajo` (paths inside must start with `trabajo/`, i.e. run `tar` from the current directory).

Without extracting anything, then print:

1. the **sorted** list of paths it contains, one per line (`tar -tjf entrega.tar.bz2 | sort`)
2. a line `---`
3. only the number of entries

Use `tar -cjf`/`tar -tjf` (bzip2), not gzip.

---
Write your solution in `answer.sh`, then run `check 0411`.  
To experiment with the same test files the checker uses: `play 0411`.
