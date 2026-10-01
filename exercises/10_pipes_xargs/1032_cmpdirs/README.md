# 1032 · cmpdirs.sh (compare two directory trees)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** find | sed | sort, comm / diff, cmp -s, exit codes like diff

Write `cmpdirs.sh`, which compares the **regular files** of two directory trees by their path
relative to each directory:

```
cmpdirs.sh DIR1 DIR2
```

Print, in this order:

1. `- <rel>` for every file that exists only in `DIR1`
2. `+ <rel>` for every file that exists only in `DIR2`
3. `* <rel>` for every file that exists in both but with **different content** (`cmp -s`)

Each group sorted by relative path (as `sort` orders them); `<rel>` has no leading `./` (e.g.
`sub dir/a.txt`). A path that is a regular file in one tree but not in the other (missing, or a
directory there) counts as "only in". Finish with

```
<S> identical, <D> different, <A> only in DIR1, <B> only in DIR2
```

(`DIR1`/`DIR2` replaced by the arguments as given). Like `diff`, the exit code is **0** if there are
no differences and **1** if there is any. Errors (message on **stderr**):

- not exactly 2 arguments: usage, exit **2**
- `DIR1` or `DIR2` is not a directory: exit **3** (the message must include its name)

Hint: `(cd DIR && find . -type f) | sed 's#^\./##' | sort` gives the relative paths; `comm` or
a loop with `[ -f ]` separates them.
