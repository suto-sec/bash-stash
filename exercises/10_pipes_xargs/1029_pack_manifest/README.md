# 1029 · pack.sh (archive the files of a manifest)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** while read, grep -v, tar -czf, arrays / xargs -d

Write `pack.sh`:

```
pack.sh MANIFEST ARCHIVE
```

`MANIFEST` lists paths (relative to the current directory), one per line; they may contain spaces.
Empty lines and lines starting with `#` are ignored. For every other line, in order:

- if it is a regular file, it will be packed;
- if it does not exist, print `missing: <path>` on stdout;
- if it exists but is not a regular file, print `skipped: <path>` on stdout.

Then create the compressed archive `ARCHIVE` (`tar -czf`, overwriting it if it exists) containing
**exactly** the files to pack, with the paths as written in the manifest, and print

```
Packed <N> files (<M> missing, <K> skipped)
```

Validation, in this order (message on **stderr**):

- not exactly 2 arguments: usage, exit **1**
- `MANIFEST` is not a readable regular file: exit **2**
- `ARCHIVE` does not end in `.tar.gz`: exit **3**
- after processing the manifest (the `missing:`/`skipped:` lines are printed), there is no file to
  pack: error on stderr, exit **4**, and no archive is created.

---
Write your solution in `answer.sh`, then run `check 1029`.  
To experiment with the same test files the checker uses: `play 1029`.
