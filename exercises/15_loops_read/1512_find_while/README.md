# 1512 · Safe loop over find results

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** find -print0, while IFS= read -r -d ''

Under `docs` there are files with **spaces** (and even newlines are possible in real life).
For each regular file (sorted by path), print `path (N bytes)`. Use
`find docs -type f -print0 | sort -z | while IFS= read -r -d '' f; do ... done`.
