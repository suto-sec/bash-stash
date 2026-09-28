# 0314 · Following link chains

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** readlink, readlink -f

The current directory contains a chain of symbolic links: `link1 → link2 → ... → real/file`.
Print:

1. the target **stored** in `link1` (one level)
2. the **final canonical absolute path** after following the whole chain

---
Write your solution in `answer.sh`, then run `check 0314`.  
To experiment with the same test files the checker uses: `play 0314`.
