# 0221 · mkskel.sh: a directory skeleton from a spec file

**Topic:** Directories & navigation · **Difficulty:** ★★★★☆ · **Commands:** while IFS= read -r, mkdir -p, [[ ]], exit codes

Write `mkskel.sh`:

```
mkskel.sh SPECFILE DEST
```

`SPECFILE` lists, one per line, directory paths **relative to** `DEST`, which may contain spaces.
Empty lines and lines starting with `#` are ignored; the other lines are used exactly as written.

- If `DEST` does not exist, create it (with parents) and print `Created DEST`.
- Then, for each path line, in file order:
  - if it is **absolute** (starts with `/`) or has a `..` component (the line is `..`, or starts with
    `../`, ends with `/..` or contains `/../`): print `skipped: <line>` on **stderr**
    (`a..b` is a normal name, not a `..` component)
  - else, if `DEST/<line>` is already a directory: print `exists: <line>`
  - else create it with `mkdir -p`: `created: <line>` on success, or `error: <line>` on **stderr**
    if it fails (e.g. a part of the path is a regular file; discard `mkdir`'s own message)
- Last line: `Created C, existing E, skipped S, errors X`

Exit codes:

- not exactly 2 arguments: usage on stderr, exit **1**
- `SPECFILE` is not a readable regular file: stderr (mention it), exit **2**
- `DEST` exists but is not a directory: stderr (mention it), exit **3**
- otherwise: **0** if every line was skipped-free and error-free, **4** if S + X > 0
