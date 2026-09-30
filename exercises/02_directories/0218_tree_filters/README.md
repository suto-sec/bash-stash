# 0218 · tree: patterns, pruning and full paths

**Topic:** Directories & navigation · **Difficulty:** ★★★☆☆ · **Commands:** tree -P, --prune, -I, -a, -f, -i

The directory `proyecto` contains sources, headers, objects, a `build` directory and a `docs`
directory with hidden files. Print, each one **without** the final summary line (`--noreport`):

1. the tree of `proyecto` showing **only** the `*.c` files, and **not** showing directories that end up
   with no `.c` inside (`-P` and `--prune`)
2. a line `---`
3. the tree of `proyecto` **ignoring** everything named `build` or ending in `.o` (`-I` with the
   pattern `build|*.o`)
4. a line `---`
5. the content of `proyecto/docs` **including hidden files**, as a flat list of **full paths**
   without indentation lines (`-a`, `-f`, `-i`)

---
Write your solution in `answer.sh`, then run `check 0218`.  
To experiment with the same test files the checker uses: `play 0218`.
