# 1818 · Lowercasing names safely

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** for, ${x,,}, mv, test -e

Write `minusculas.sh [DIR]` (default: current directory) that renames every entry (file or directory,
not hidden) **directly inside** `DIR` whose name has uppercase letters to its lowercase version.
If the lowercase name already exists, don't rename: print `skip <name>: <lower> exists` on **stderr**.

Print `<name> -> <lower>` on stdout for each rename (in alphabetical order of the original names, as the
`*` glob gives them), then `Renamed N entries`. Exit 0. Not a directory: stderr, exit 1.

---
Write your solution in `answer.sh`, then run `check 1818`.  
To experiment with the same test files the checker uses: `play 1818`.
