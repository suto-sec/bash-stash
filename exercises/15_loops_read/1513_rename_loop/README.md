# 1513 · Batch rename

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** for, mv, ${f%.*}

Rename every `.jpeg` file in `fotos` to `.jpg`, and every file whose name contains spaces so that
spaces become `_` (both rules may apply to the same file). Print `old -> new` for each renamed file,
in alphabetical order of the old name. Files needing no change are not printed.
