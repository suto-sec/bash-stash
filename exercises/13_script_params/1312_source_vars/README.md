# 1312 · source vs executing

**Topic:** Script parameters & exit codes · **Difficulty:** ★★☆☆☆ · **Commands:** source, ., bash

`config.sh` (in the current directory) sets `SERVER=...` and `PORT=...` and also does `cd /tmp`.

1. Run it as `bash config.sh` and then print `[$SERVER:$PORT]` and `pwd`.
2. Now load it with `source config.sh` and print `[$SERVER:$PORT]` and `pwd` again.

Understand why the first time the variables are empty and the directory doesn't change.
