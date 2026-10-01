# 0821 · fixperms.sh (normalising a tree)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** find, stat -c %a, chmod, [[ =~ ]], sort, exit codes

Write:

```
fixperms.sh DIR FILEMODE DIRMODE
```

It sets every **regular file** under `DIR` (recursively) to `FILEMODE` and every **directory** under
`DIR` (recursively, `DIR` itself included) to `DIRMODE`. Symbolic links are ignored.

Output: for every entry whose mode actually changes, sorted by path (paths as `find DIR` prints them,
sorted with `sort`):

```
<path>: <old> -> <new>
```

(`<old>` as `stat -c %a` prints it, `<new>` as given), then `Changed N of M entries`, where `M` is the
number of files + directories examined.

Errors (message on stderr), checked in this order:

- not exactly 3 arguments → usage, exit **1**
- `DIR` is not a directory → exit **2**
- `FILEMODE` or `DIRMODE` is not exactly 3 octal digits → exit **3**, message including the wrong mode
- `DIRMODE` does not start with `7` (the owner must keep `rwx` on directories) → exit **4**

Names may contain spaces.
