# 0726 · Copying a directory skeleton

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -type d, mkdir -p, while read

Create `dst` with the same **directory structure** as `src`: every directory under `src` (at any
depth, including hidden ones and empty ones) must exist at the same relative place under `dst`.
**No files** are copied, and symbolic links are not copied either (not even links to directories).

Finally print `Created N directories`, where N is the number of directories under `src`,
**not counting** `src` itself. Names may contain spaces.

Example: `src/a/b c` must produce `dst/a/b c`.

---
Write your solution in `answer.sh`, then run `check 0726`.  
To experiment with the same test files the checker uses: `play 0726`.
