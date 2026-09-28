# 1808 · Removing big files from a .tgz

**Topic:** Exam-style scripts · **Difficulty:** ★★★★★ · **Commands:** mktemp -d, tar -xzf -C, find -size, tar -czf

Write `podar.sh ARCHIVE.tgz [KB]` that removes from **inside** the archive every regular file bigger than
`KB` kibibytes (default 8, i.e. size > 8192 bytes). The archive is replaced by the new one (same name),
keeping the same internal paths for the remaining entries.

Print `Removed <path> (<bytes> bytes)` for each removed file (path as stored in the archive, sorted),
then `Kept N files, removed M files`.

- wrong number of arguments: usage on stderr, exit 1
- the archive doesn't exist or is not a valid `.tgz` (`tar -tzf` fails): stderr, exit 2
- `KB` not a positive integer: stderr, exit 3

Use a temporary directory (`mktemp -d`) and delete it at the end.

---
Write your solution in `answer.sh`, then run `check 1808`.  
To experiment with the same test files the checker uses: `play 1808`.
