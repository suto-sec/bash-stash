# 0325 · relink.sh (fixing links after a move)

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** find -type l, readlink, ln -sfn, ${var#prefix}, sort

A directory was moved and many symbolic links still point to its old location. Write:

```
relink.sh DIR OLD NEW
```

For every symbolic link under `DIR` (recursively, `find`), look at its **stored target** (`readlink`).
If the target is exactly `OLD`, or starts with `OLD/`, replace the link by one whose target has that
`OLD` prefix replaced by `NEW` (the rest of the target is kept). Example with `OLD=/srv/datos`,
`NEW=/mnt/datos`: `/srv/datos/a/b.txt` becomes `/mnt/datos/a/b.txt`, but `/srv/datos2/x` and
`/srv/datos_old` are **not** touched.

Output: for every changed link, sorted by its path (as `find DIR` prints it, sorted with `sort`):

```
<link path>: <old target> -> <new target>
```

then the summary `Relinked N of M links`, where `M` is the total number of symbolic links under `DIR`.
Links must keep their names (which may contain spaces); some links point to directories.

Errors (message on stderr):

- not exactly 3 arguments → usage, exit **1**
- `DIR` is not a directory → exit **2** (the message includes `DIR`)
- `OLD` or `NEW` is an empty string → exit **3**
