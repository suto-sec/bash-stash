# 0408 · Backup and verify

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** tar -czf, tar -xzf, mktemp -d, diff -r

Make a backup of the directory `proyecto` into `proyecto.tgz`, then verify it:

1. create a temporary directory with `mktemp -d`
2. extract the archive there
3. compare it with the original using `diff -r`; print `backup OK` if identical, `backup FAILED` otherwise
4. remove the temporary directory

Only `backup OK` (or `FAILED`) must be printed.
