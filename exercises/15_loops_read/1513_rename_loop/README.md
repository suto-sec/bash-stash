# 1513 · Batch rename

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** for, mv, ${f%.*}

Rename every `.jpeg` file in `fotos` to `.jpg`, and every file whose name contains spaces so that
spaces become `_` (both rules may apply to the same file). Print `old -> new` for each renamed file,
in alphabetical order of the old name. Files needing no change are not printed.

---
Write your solution in `answer.sh`, then run `check 1513`.  
To experiment with the same test files the checker uses: `play 1513`.
