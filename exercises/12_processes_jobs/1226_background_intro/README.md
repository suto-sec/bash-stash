# 1226 · &: running a command in the background

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** &, $!, wait

Run `sleep 0.2` in the **background** (`&`) and save its PID with `$!`. Print `launched`
right away (before waiting: `&` returns immediately). Then `wait` for the process and print
`done`.

---
Write your solution in `answer.sh`, then run `check 1226`.  
To experiment with the same test files the checker uses: `play 1226`.
