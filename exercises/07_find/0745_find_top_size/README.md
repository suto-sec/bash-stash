# 0745 · The largest files: find + xargs + sort + head

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -print0, xargs -0, stat -c, sort -k, head

Under `media`, print the **3 largest regular files** by size, one per line as `SIZE PATH` (size in
bytes, path exactly as `find` prints it), ordered by size **descending**; break ties by path
**ascending**.

Pipeline: `find media -type f -print0 | xargs -0 stat -c '%s %n' | sort -k1,1nr -k2,2 | head -n 3`.
A broken symlink is planted as a decoy — `-type f` must exclude it.

---
Write your solution in `answer.sh`, then run `check 0745`.  
To experiment with the same test files the checker uses: `play 0745`.
