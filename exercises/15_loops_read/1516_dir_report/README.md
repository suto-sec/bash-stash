# 1516 · Directory report

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** for, test, wc, stat

The script receives a directory. For each entry (alphabetical, including hidden ones but not `.`
and `..`) print one line:

- `[D] name (N entries)` for directories (N = number of entries inside, hidden included)
- `[F] name (N bytes)` for regular files
- `[L] name -> target` for symbolic links (check first)

At the end: `Total: X dirs, Y files, Z links`.

---
Write your solution in `answer.sh`, then run `check 1516`.  
To experiment with the same test files the checker uses: `play 1516`.
