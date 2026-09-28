# 0609 · Searching in many files

**Topic:** grep & regular expressions · **Difficulty:** ★★☆☆☆ · **Commands:** grep -l, -r, -c, -h

The directory `src` contains source files in several subdirectories. Print separated by `---`:

1. the **names** of files (recursive) that contain `TODO` (`-rl`), sorted
2. for each `.c` file directly in `src`, `file:count` of lines with `TODO` (`-c`)
3. all lines with `TODO` in any file, **without** the file name prefix (`-rh`), sorted

---
Write your solution in `answer.sh`, then run `check 0609`.  
To experiment with the same test files the checker uses: `play 0609`.
