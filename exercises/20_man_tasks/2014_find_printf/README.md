# 2014 · Sizes and paths

**Topic:** Man page tasks · **Difficulty:** ★★★☆☆ · **Commands:** find, sort

The folder `arbol` contains files in several levels. Print one line for each **regular file** under it, with its **size in bytes**, a space, and its path (as `find` prints it, starting with `arbol/`). Order the lines alphabetically by path.

Example: `120 arbol/a.txt`, `45 arbol/sub/b.txt`.

Don't call `stat` or `wc` on every file: `find` can print the size by itself. Look at the `-printf` formats in `man find`.
