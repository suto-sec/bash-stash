# 0822 · perm_diff.sh (comparing permissions of two trees)

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★★★★☆ · **Commands:** find, stat -c %a, sort -u, test -f, exit codes

After restoring a backup you want to know whether permissions survived. Write:

```
perm_diff.sh DIR1 DIR2
```

Consider the **regular files** under each directory (recursively), identified by their path
**relative** to that directory (e.g. `sub/a.txt`, no leading `./`). For every relative path that exists
in either tree, in the order given by `sort` over all the relative paths, print:

- `DIFF <path>: <mode1> <mode2>` if it is a regular file in both and the modes differ (`stat -c %a`)
- `ONLY1 <path>` if it is only in `DIR1`, `ONLY2 <path>` if it is only in `DIR2`
- nothing if the modes are equal

Then print `Summary: D different, A only in DIR1, B only in DIR2` (with the words `DIR1`/`DIR2`
literally).

Exit codes: **0** if the trees have no differences at all (`D`, `A` and `B` are 0), **1** if they have
some; **2** if there are not exactly 2 arguments (usage on stderr); **3** if one of them is not a directory
(stderr message including its name). Names may contain spaces.
