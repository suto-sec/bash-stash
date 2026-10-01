# 1328 · samelines.sh: do two files have the same lines?

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** sort -u, grep -F -x -v -f, exit status 0/1/2 like diff

Write `samelines.sh`, which compares the **sets** of lines of two files (order and repetitions do
not matter), and reports through its exit code like `diff`/`cmp` do:

```
samelines.sh [-q] file1 file2
```

Output (unless `-q`, the first argument, is given; with `-q` print nothing on stdout):

1. every distinct line that is only in `file1`, prefixed by `< `, sorted with `sort`
2. every distinct line that is only in `file2`, prefixed by `> `, sorted with `sort`
3. `Common: C, only in <file1>: A, only in <file2>: B` (C = distinct lines present in both;
   file names as given)

Lines are compared **whole** (`apple` is not the same line as `apple pie`).

Exit codes:

| situation | exit |
|-----------|------|
| same set of lines | 0 |
| different | 1 |
| wrong number of arguments (show the usage on stderr) | 2 |
| a file is not a readable regular file (message on stderr naming it) | 3 |
