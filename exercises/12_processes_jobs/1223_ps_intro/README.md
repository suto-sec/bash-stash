# 1223 · ps: checking a process exists

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** ps -p

Start `sleep 300` in the **background** and save its PID (`$!`). Print `found` if `ps -p PID`
succeeds (exit code 0, redirect its output to `/dev/null`), or `not found` otherwise.

---
Write your solution in `answer.sh`, then run `check 1223`.  
To experiment with the same test files the checker uses: `play 1223`.
