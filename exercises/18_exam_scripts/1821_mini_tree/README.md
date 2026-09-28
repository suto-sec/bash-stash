# 1821 · A tree command without find or tree

**Topic:** Exam-style scripts · **Difficulty:** ★★★★★ · **Commands:** recursive function, for, test -d -L, printf

Write `arbol.sh [DIR]` (default `.`) that prints a tree **without using `find`, `tree` or `ls -R`**,
with a recursive function:

- first line: `DIR` as given
- then every entry (not hidden), in the order of the `*` glob, indented with **2 spaces per level**
  (first level: 2 spaces)
- directories are printed with a trailing `/` and their content follows (recursively)
- symbolic links are printed as `name -> target` and **never** followed
- last line: `N directories, M files` (links count as files)

Not a directory: stderr, exit 1.

---
Write your solution in `answer.sh`, then run `check 1821`.  
To experiment with the same test files the checker uses: `play 1821`.
