# 0730 · flatten.sh: collecting files into one folder

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -name, sort, cp, basename, while read, name collisions

Write `flatten.sh`:

```
flatten.sh SRC DEST EXT
```

It **copies** every regular file under `SRC` (recursively) whose name ends in `.EXT` (case-sensitive)
into the directory `DEST`, **flat** (no subdirectories).

- If `DEST` does not exist, create it and print `Created DEST` (as given) first.
- Files are processed in **sorted path order** (`find ... | sort`).
- **Name collisions**: if `DEST/NAME` already exists (from a previous copy of this run or from before),
  the copy is named `BASE_2.EXT`, or `BASE_3.EXT` if that one also exists, and so on (the first free
  number starting at 2). `BASE` is the name without the final `.EXT` (`my notes.txt` → `my notes_2.txt`).
- For each copy print `<source path> -> <name in DEST>` (source path as `find` prints it).
- Finally print `Copied N files`.

Checks, **in this order** (messages on stderr, wording free):

- not exactly 3 arguments: usage, exit **1**
- `SRC` is not a directory: exit **2**
- `DEST` exists but is not a directory: exit **3**
- `EXT` is empty or contains anything other than letters and digits: exit **4**

`DEST` is never inside `SRC`. Names may contain spaces.
