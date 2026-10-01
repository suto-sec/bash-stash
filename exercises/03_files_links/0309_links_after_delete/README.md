# 0309 · What survives a deletion

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** ln, ln -s, rm, cat, test

The file `original` exists in the current directory.

1. Create a hard link `duro` and a symbolic link `blando` (target: `original`).
2. Delete `original`.
3. Print the content of `duro`.
4. Print `broken` if `blando` is a broken link (`[ -e blando ]` follows the link), `ok` otherwise.
5. Print the link count of `duro` (`stat -c %h`).

Think about **why** the hard link survives and the symbolic one does not.
