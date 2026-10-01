# 0827 · runall.sh (run the executable scripts of a folder)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** test -x -f -L, "${@:2}", $?, exit codes

Write:

```
runall.sh DIR [ARG...]
```

For every entry of `DIR` in the order of the `DIR/*` glob (symbolic links and anything that is not a
regular file are ignored silently):

- if **you** can execute it (`test -x`): print `== NAME ==`, run it passing all the `ARG`s (its output
  appears as it is; its stderr is not redirected), then print `exit: N` with its exit code
- otherwise print `skip NAME (not executable)`

(`NAME` is the file name without the directory.) Finally print `ran R, skipped S, failed F`, where
`F` counts the scripts that ended with a non-zero exit code.

Exit codes: **1** no arguments (usage on stderr); **2** `DIR` is not a directory (stderr, including its
name); **3** if at least one script failed; **0** otherwise. Names and arguments may contain spaces.
