# 0333 · Grouping files that are secretly the same

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** test -ef, test -L, basename

The directory `almacen` contains a flat set of regular files and a couple of symbolic links (ignore
the symlinks entirely). Several of the regular files are actually **hard links** to each other (the
same inode under different names); others merely happen to have identical content but are separate
files.

Find the groups of names that are hard links of each other. For every such group that has **two or
more** names, print one line with the names **space-separated**, in the order they appear in the
`almacen/*` glob; order the lines themselves by the group's first (glob-order) name. Files that are
not hard-linked to anything else (a group of one) are not printed at all. Finally print `Groups: N`
(`N` = number of printed groups).

Hint: `[ A -ef B ]` is true when `A` and `B` are the same file (same inode), i.e. hard links of each other; your script must use `-ef`.
