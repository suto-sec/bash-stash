# 0406 · gzip and gunzip

**Topic:** tar, gzip & compression · **Difficulty:** ★★☆☆☆ · **Commands:** gzip, gunzip, zcat

The directory `logs` contains several `.log` files and one `old.log.gz`.

1. Compress every `.log` file in `logs` with `gzip` (each becomes `.log.gz`, the original disappears).
2. Before that, print the content of `logs/old.log.gz` **without** decompressing it on disk (`zcat`
   or `gzip -dc`).
3. Finally decompress `logs/old.log.gz` back to `logs/old.log`.

---
Write your solution in `answer.sh`, then run `check 0406`.  
To experiment with the same test files the checker uses: `play 0406`.
