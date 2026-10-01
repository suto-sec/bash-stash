# 0328 · versions.sh (numbered copies)

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** cp -p, cmp -s, basename, for, [[ =~ ]], exit codes

Write a tiny version keeper:

```
versions.sh FILE [DIR]
```

Versions of `FILE` are kept in `DIR` (default `$HOME/versions`) as `<name>.v1`, `<name>.v2`, ... where
`<name>` is the basename of `FILE`. Numbers may have gaps (`v1 v2 v5`); the **latest** version is the
one with the biggest number (numerically: `v10` > `v9`). Other files in `DIR` (e.g. `<name>.vold`,
`<name>.v3.bak`, versions of other files) are not versions and must be ignored.

1. If `DIR` does not exist, create it (with parents) and print `Created <DIR>`.
2. If there is a latest version and its content is identical to `FILE`, print `No changes since v<N>`
   and copy nothing.
3. Otherwise copy `FILE` as version latest+1 (or `v1` if there is none) preserving its mode and
   modification time (`cp -p`), and print `Saved <FILE> as <DIR>/<name>.v<K>`.
4. Finally print `<V> versions of <name>` (how many versions exist now).

`<DIR>` and `<FILE>` are printed as given (or the default `$HOME/versions` fully expanded).

Errors (message on stderr): no arguments or more than 2 → usage, exit **1**; `FILE` is not a regular
file → exit **2**; `DIR` exists but is not a directory → exit **3**.
