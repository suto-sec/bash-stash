# 0335 · sync_copy.sh: copying only what changed

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** find, stat -c %Y, mkdir -p, cp -p, dirname, exit codes

Write `sync_copy.sh`:

```
sync_copy.sh SRC DST
```

For every **regular file** under `SRC` (recursively; symbolic links are ignored), let `REL` be its
path relative to `SRC` (no leading `./`). Copy it into `DST/REL` (creating whatever directories are
needed) **only** when:

- `DST/REL` does not exist yet, or
- `DST/REL` exists but its modification time (`stat -c %Y`) is **older** than `SRC/REL`'s

preserving permissions and modification time (`cp -p`). Files that already look up to date are left
untouched (not even their timestamp changes) and are not printed. Anything that exists only under
`DST` is ignored.

For every file actually copied, print `REL` (as computed above), in the sorted order of
`find SRC -type f`. Finally print `Copied C of T files` (`T` = total regular files found under `SRC`).

Errors (message on stderr):

- not exactly 2 arguments → usage, exit **1**
- `SRC` is not a directory → exit **2** (message includes `SRC`)
- `DST` exists and is not a directory → exit **3** (message includes `DST`)

`DST` is created (with parents) if it does not exist. Names may contain spaces.
