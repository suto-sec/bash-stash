# 1224 · kill: terminating a background process

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** kill, wait

Start `sleep 300` in the background and save its PID. Terminate it with `kill` (default signal,
SIGTERM), then `wait` for it and print the exit status returned by `wait` (a process killed by
SIGTERM exits with `143`).

---
Write your solution in `answer.sh`, then run `check 1224`.  
To experiment with the same test files the checker uses: `play 1224`.
