# 0305 · Deleting with wildcards

**Topic:** Files, copies & links · **Difficulty:** ★★☆☆☆ · **Commands:** rm, *, ?, [...]

The current directory contains many `Trimestre.*` files. Using **wildcards** (not listing names one by one):

1. Delete every file whose name is `Trimestre.17` followed by anything.
2. Delete the files named `Trimestre.18.` followed by a `1` or a `2` and ending in `.txt`.
3. Delete every file whose name has exactly **one character** before `.log` (e.g. `a.log`, not `ab.log`).

Leave everything else untouched.

---
Write your solution in `answer.sh`, then run `check 0305`.  
To experiment with the same test files the checker uses: `play 0305`.
