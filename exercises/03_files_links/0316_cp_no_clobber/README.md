# 0316 · Copying without overwriting

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** cp, test -e, basename, for

The directory `nuevos` contains new files; some of them already exist (same name, maybe different
content) in the directory `archivo`.

Copy every **regular file** directly inside `nuevos` into `archivo`, but **never overwrite** a file
that already exists in `archivo`. Subdirectories of `nuevos` are ignored (not copied, not printed).

Output, following the order of the `nuevos/*` glob:

- `skipped <name>` for every file that was not copied because it already existed in `archivo`
  (`<name>` is the file name without the directory)

and finally the line `copied N` with the number of files actually copied. File names may contain spaces.
