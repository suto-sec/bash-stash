# 1801 · deploy_bins.sh

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -perm /111, cp, mkdir -p, while read, exit codes

Write `deploy_bins.sh`:

```
deploy_bins.sh [directory]
```

It finds and **copies** to `$HOME/deploy/bin` every **regular file** (not directories) under
`directory` (including subdirectories) that has **some** execute permission enabled and whose name
ends in `.sh` or `.bin`.

- More than one argument: print an error message **and the correct usage**, exit code **1**.
- `directory` does not exist: error message (including the name), exit code **2**.
- `directory` exists but is not a directory: error message (including the name), exit code **3**.
- No argument: use the current directory.
- If `$HOME/deploy/bin` does not exist, create it and print exactly
  `Directory <full path> created` on stdout.
- Existing files in the destination are overwritten.
- Count the files **successfully** copied and print exactly `Copied N files` on stdout.

Error messages go to **stderr** (wording is free). File names may contain spaces.
Some files may be unreadable: `cp` fails for them, and they must not be counted.

---
Write your solution in `answer.sh`, then run `check 1801`.  
To experiment with the same test files the checker uses: `play 1801`.
