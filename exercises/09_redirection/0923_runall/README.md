# 0923 · runall.sh (running scripts with their output logged)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** cmd < /dev/null > out 2> err, $?, test -s, wc -l <

Write `runall.sh`:

```
runall.sh DIR [LOGDIR]
```

It runs, in the order of the `DIR/*.sh` glob, every **regular file** directly in `DIR` whose name
ends in `.sh` and that is **executable** (others are skipped silently), with no arguments and:

- stdin from `/dev/null` (the scripts must not read the input of `runall.sh`!)
- stdout to `LOGDIR/<name>.out` and stderr to `LOGDIR/<name>.err`, where `<name>` is the file name
  without `.sh` (both files overwritten if they exist)

`LOGDIR` defaults to `DIR/logs`; create it (with parents) if needed. After each run, delete the
`.err` file if it is empty, and print

```
<name>: exit <code>, <o> out, <e> err
```

(`o`/`e` = number of lines written to stdout/stderr). Finally print `<N> scripts, <F> failed`
(`F` = runs with a non-zero exit code). Exit code: 0 if `F` is 0, **5** otherwise.

Errors (message on **stderr**): no arguments or more than 2 → usage, exit **1**; `DIR` is not a
directory → exit **2**; `LOGDIR` exists and is not a directory → exit **3**.
