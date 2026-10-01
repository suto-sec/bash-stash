# 1428 · newer_than.sh: files changed since a reference

**Topic:** test, if & case · **Difficulty:** ★★★★☆ · **Commands:** find -type f, sort, test -nt -ot -ef, exit codes

Write `newer_than.sh`:

```
newer_than.sh ref directory
```

Compare the modification time of every **regular file** under `directory` (recursively; as found by
`find directory -type f`, sorted with `sort`) with the one of `ref`, and print three sections:

```
Newer than <ref>:
  <path>
Older than <ref>:
  <path>
Same age as <ref>:
  <path>
Summary: N newer, O older, S same
```

(paths indented by two spaces; a section with no files is just its header line). `ref` itself is
skipped if it is one of the files (`-ef`). Use `-nt` / `-ot`.

Errors (message on **stderr**, wording free), checked in this order:

| error | exit |
|-------|------|
| not exactly 2 arguments (show the usage) | 1 |
| `ref` does not exist (name it) | 2 |
| `directory` is not a directory (name it) | 3 |
