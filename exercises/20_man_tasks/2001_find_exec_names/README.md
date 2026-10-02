# 2001 · The deploy_bins search

**Topic:** Exam tasks with the manual · **Difficulty:** ★★★☆☆ · **Commands:** find

The folder `app` has files and folders at several levels.

Print the path of every **regular file** below `app` that has **at least one execute permission bit** (owner, group or others) **and** whose name ends in `.sh` or `.bin`. One path per line, in alphabetical order.

Careful with: files with the right name but no execute permission, executable files with another extension, and a folder whose name ends in `.sh`.

This is the search at the heart of the June exam script. The exact meaning of `-perm /mode`, `-perm -mode` and `-perm mode` is in the TESTS part of `man find`; read it once, you will need it.
