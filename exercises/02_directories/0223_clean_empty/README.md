# 0223 · cleanempty.sh: removing empty directory trees

**Topic:** Directories & navigation · **Difficulty:** ★★★★☆ · **Commands:** rmdir, find -depth, du, sort, exit codes

Write `cleanempty.sh`:

```
cleanempty.sh DIR
```

It removes every **empty directory** under `DIR` (recursively), **including** directories that only
become empty after their empty subdirectories are removed. `DIR` itself is never removed. A directory
that contains anything else (a file, a hidden file, a symbolic link...) is kept.

Output: `removed <path>` for each removed directory, **sorted** (`sort`), with paths written as
`DIR/...` (`DIR` exactly as given, without a trailing `/`), then
`Removed N directories, M remain`, where M is the number of directories that remain **under** `DIR`
(not counting `DIR` itself).

Errors (message on stderr, mentioning `DIR` when there is one):

- not exactly one argument: usage, exit **1**
- `DIR` does not exist: exit **2**
- `DIR` exists but is not a directory: exit **3**

Hint: process the directories **deepest first** (`find -depth`, or the order `du` prints them) and try
`rmdir` on each one: it fails harmlessly on non-empty directories.

---
Write your solution in `answer.sh`, then run `check 0223`.  
To experiment with the same test files the checker uses: `play 0223`.
