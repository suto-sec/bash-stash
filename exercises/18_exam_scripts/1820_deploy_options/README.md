# 1820 · deploy_bins with options (-n dry run, -m move)

**Topic:** Exam-style scripts · **Difficulty:** ★★★★★ · **Commands:** while case shift, options parsing

Extend the deploy script (1801): `deploy2.sh [-n] [-m] [directory]` (options in any order, before the directory).

- `-n` (dry run): don't touch anything; print `would <copy|move>: <path>` for each matching file
  (sorted by path) and finally `N files would be <copied|moved>`. Don't create the destination either.
- `-m`: **move** instead of copy (final message `Moved N files`).
- no options: behave exactly like `deploy_bins.sh` (1801) (copy, `Copied N files`, `Directory ... created`).
- unknown option (anything starting with `-`): usage on stderr, exit 1. More than one directory: exit 1.
- the directory checks and exit codes 2 and 3 are the same as in 1801.

---
Write your solution in `answer.sh`, then run `check 1820`.  
To experiment with the same test files the checker uses: `play 1820`.
