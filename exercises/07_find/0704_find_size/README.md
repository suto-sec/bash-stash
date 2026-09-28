# 0704 · Searching by size

**Topic:** find · **Difficulty:** ★★☆☆☆ · **Commands:** find -size

Under `datos`, print sorted, separated by `---`:

1. regular files **bigger than 2 MiB** (`-size +2M`)
2. regular files **smaller than 10 KiB** (`-size -10k`)
3. **empty** regular files (`-empty` or `-size 0`)

(Beware: `-size -1M` means "0 blocks of 1M", i.e. only empty files. That's why we use k here.)

---
Write your solution in `answer.sh`, then run `check 0704`.  
To experiment with the same test files the checker uses: `play 0704`.
