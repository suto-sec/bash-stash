# 0411 · Creating and listing a .tar.bz2

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** tar -cjf, tar -tjf, sort

Create a bzip2-compressed archive `entrega.tar.bz2` containing everything under the directory
`trabajo` (paths inside must start with `trabajo/`, i.e. run `tar` from the current directory).

Without extracting anything, then print:

1. the **sorted** list of paths it contains, one per line (`tar -tjf entrega.tar.bz2 | sort`)
2. a line `---`
3. only the number of entries

Use `tar -cjf`/`tar -tjf` (bzip2), not gzip.
