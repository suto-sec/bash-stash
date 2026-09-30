# 0736 · cambiaext.sh: changing extensions recursively

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -name, mv, parameter expansion ${f%.ext}, exit codes

Write `cambiaext.sh`:

```
cambiaext.sh DIR OLD NEW
```

It renames every **regular file** under `DIR` (recursively) whose name ends in `.OLD` (case-sensitive)
so that it ends in `.NEW` instead (`a b.jpeg` → `a b.jpg`, in the same directory). Files are processed
in sorted path order. For each rename print

```
renamed <old path> -> <new path>
```

(paths as `find` prints them). If the new name **already exists**, don't rename that file: print
`skip <old path>: <new path> exists` on **stderr** and go on. Finally print
`Renamed N files, skipped M` on stdout.

Exit code: **4** if some file was skipped, 0 otherwise. Checks, **in this order** (stderr, wording free):

- not exactly 3 arguments: usage, exit **1**
- `DIR` is not a directory: exit **2**
- `OLD` or `NEW` is empty, or they are equal: exit **3**

Directories are never renamed. Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0736`.  
To experiment with the same test files the checker uses: `play 0736`.
