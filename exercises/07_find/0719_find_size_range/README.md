# 0719 · Size ranges in bytes

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -size Nc, -size +N -size -M, stat -c

Under `data`, print, separated by `---`:

1. every **regular file** whose size is **between 1000 and 5000 bytes, both included**, as
   `<bytes> <path>`, sorted by size (ascending) and then by path. Use the `c` (bytes) unit of `-size`:
   `+N` means "more than N" and `-N` "less than N".
2. the regular files whose size is **from 1 to 1024 bytes** (both included), sorted.
   (Fun fact: that is exactly what `-size 1k` matches, because find rounds sizes **up** to whole
   units; and it is why `-size -1k` only matches empty files.)

---
Write your solution in `answer.sh`, then run `check 0719`.  
To experiment with the same test files the checker uses: `play 0719`.
