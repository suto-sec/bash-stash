# 0327 · skeleton.sh (an empty copy of a tree)

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** find, mkdir -p, touch -r, ${p#prefix}

Write `skeleton.sh SRC DST` that creates in `DST` an "empty copy" of the tree `SRC`:

- every directory under `SRC` (recursively, hidden ones included) is created at the same relative path
  under `DST`
- every **regular file** under `SRC` becomes an **empty** file at the same relative path under `DST`,
  with the **same modification time** as the original (`touch -r`)
- symbolic links and anything else are ignored

`DST` must not exist: the script creates it (and its missing parents). At the end print
`N directories, M files`, counting what was created **inside** `DST` (not `DST` itself).
Names may contain spaces.

Errors (message on stderr):

- not exactly 2 arguments → usage, exit **1**
- `SRC` is not a directory → exit **2**
- `DST` already exists → exit **3** (nothing is modified)

(`SRC` is given without a trailing `/`.) The checker compares contents, permissions and the modification
times of the files created.
