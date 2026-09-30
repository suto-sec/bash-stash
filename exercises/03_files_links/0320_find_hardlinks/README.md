# 0320 · Who else is this file?

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** test -ef, test -L, stat -c %h %i

The directory `datos` contains a file `master` and many other entries: some are **hard links** to
`master`, some are copies with the same content, some are symbolic links to it.

1. Print the name (without the directory) of every entry directly inside `datos`, other than `master`
   itself, that is a **hard link** to the same file as `datos/master` (same inode). Symbolic links do
   **not** count. Follow the order of the `datos/*` glob.
2. Print `links: N`, where `N` is the link count of `datos/master` (`stat`). It may be bigger than what
   you found: hard links can live in other directories too.

---
Write your solution in `answer.sh`, then run `check 0320`.  
To experiment with the same test files the checker uses: `play 0320`.
