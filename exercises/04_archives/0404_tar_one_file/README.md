# 0404 · Extracting a single file

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** tar -xzf FILE, tar -xOzf

`backup.tgz` contains a file whose path ends in `/config.ini` (you don't know the directory).

1. Print the **content** of that file without extracting anything to disk (see `-O`).
2. Extract **only** that file (keeping its path) into the current directory.

Hint: first find its exact path with `tar -tzf backup.tgz | grep config.ini`.

---
Write your solution in `answer.sh`, then run `check 0404`.  
To experiment with the same test files the checker uses: `play 0404`.
