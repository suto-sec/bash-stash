# 1330 · runall.sh: a batch runner that collects exit codes

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** $?, bash -c, while read, option -e, exit codes

Write `runall.sh`:

```
runall.sh [-e] file
```

`file` contains one shell command per line. Skip lines that are empty or whose first character is
`#`. Run every other line, in order, with `bash -c "<line>"` (in the current directory, with its
stdout and stderr hidden and its stdin from `/dev/null`), and print

- `[ok] <line>` if it exited with 0
- `[fail N] <line>` otherwise (N = its exit code)

If `-e` is given (only as the first argument), stop after the first failing command and print
`Stopped at line L` (L = its line number in the file, counting every line).

Finally print `Commands: N, failed: F` (N = commands actually run).

Exit codes:

| situation | exit |
|-----------|------|
| every command run succeeded | 0 |
| some command failed | 1 |
| wrong arguments (not `[-e] file`; show the usage on stderr) | 2 |
| `file` is not a readable regular file (message on stderr naming it) | 3 |
