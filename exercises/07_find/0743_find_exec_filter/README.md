# 0743 · -exec ... {} \; as a per-file test

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -exec {} \; -print, ! -path

Under `registros`, print **sorted** the regular files that contain a line **exactly equal to**
`ERROR` (case-sensitive, the whole line, nothing else on it), **excluding** anything under a
directory called `descartados`.

Use `find` with `-exec grep -qx ERROR {} \; -print`: `-exec` here works as a per-file **test**
(true/false, like `-name` or `-size`) rather than an action, so `-print` only runs for the files
where the `grep` succeeded. It must be `{} \;` (one `grep` call per file, one exit status per file) —
`{} +` would batch several files into a single `grep` call and you would lose the per-file result.
