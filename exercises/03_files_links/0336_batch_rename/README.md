# 0336 · batch_rename.sh: changing an extension in bulk, without collisions

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** find, mv, exit codes

Write `batch_rename.sh`:

```
batch_rename.sh DIR OLDEXT NEWEXT
```

For every **regular file** under `DIR` (recursively) whose name ends in exactly `.OLDEXT` (the
literal suffix, case-sensitive; only the final extension counts, so `archivo.tar.OLDEXT` becomes
`archivo.tar.NEWEXT`), rename it in place so its extension becomes `.NEWEXT` (same directory, same
rest of the name).

Process the matches in the sorted order of `find DIR -type f -name '*.OLDEXT'`. If the new name is
already taken (by another file that was already there, or by a file renamed earlier in this same
run), do **not** rename it: print `skip <old path> (<new path> already exists)` to **stderr** and
move on. Otherwise rename it and print `<old path> -> <new path>` (paths exactly as `find` printed
the old one). Finally print `Renamed N of M` (`M` = number of matches found).

Errors (message on stderr):

- not exactly 3 arguments → usage, exit **1**
- `DIR` is not a directory → exit **2** (message includes `DIR`)
- `OLDEXT` or `NEWEXT` is empty, or contains a `/` → exit **3**

Exit code (when arguments are valid): **4** if at least one match was skipped due to a collision,
**0** otherwise. Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0336`.  
To experiment with the same test files the checker uses: `play 0336`.
