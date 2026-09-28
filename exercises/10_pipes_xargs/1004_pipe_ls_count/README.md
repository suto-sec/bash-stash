# 1004 · Counting directories and files

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★☆☆☆ · **Commands:** ls -l, grep ^d, wc

In the current directory, print (just numbers, one per line):

1. how many **subdirectories** there are (`ls -l | grep '^d'`)
2. how many **regular files** there are
3. on how many files **and** directories the **owner has write permission** (`ls -l | cut -c3`)
4. how many **regular files** have write permission for the owner

---
Write your solution in `answer.sh`, then run `check 1004`.  
To experiment with the same test files the checker uses: `play 1004`.
