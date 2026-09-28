# 0703 · Case-insensitive names

**Topic:** find · **Difficulty:** ★★☆☆☆ · **Commands:** find -iname, -path

Under `fotos`, print sorted:

1. files ending in `.jpg` in **any case** (`.JPG`, `.Jpg`...)
2. `---`
3. files whose path contains a directory called `2025` (`-path '*/2025/*'`)

---
Write your solution in `answer.sh`, then run `check 0703`.  
To experiment with the same test files the checker uses: `play 0703`.
