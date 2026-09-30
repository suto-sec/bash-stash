# 0721 · Hard links (-links, -samefile)

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -links, -samefile, -inum

Under `store` some files have several **hard links** (several names for the same inode).
Print, separated by `---`:

1. the **regular files** that have **more than one** hard link, sorted
2. every path under `store` that is the **same file** (same inode) as `store/original.dat`,
   including itself, sorted

A **symbolic** link to `original.dat` is a different file and must not appear in 2.

---
Write your solution in `answer.sh`, then run `check 0721`.  
To experiment with the same test files the checker uses: `play 0721`.
