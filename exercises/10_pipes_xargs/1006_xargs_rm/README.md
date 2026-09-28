# 1006 · xargs

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★☆☆☆ · **Commands:** find | xargs rm

Delete every file under the current directory whose name matches `*~`, using `find` **piped** to
`xargs rm` (no spaces in the names this time).

---
Write your solution in `answer.sh`, then run `check 1006`.  
To experiment with the same test files the checker uses: `play 1006`.
