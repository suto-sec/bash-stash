# 1204 · Stopping and resuming: process states

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** kill -STOP, kill -CONT, ps -o stat=

1. Start `sleep 200` in the background.
2. Print its state with `ps -o stat= -p PID` (should be `S`, sleeping).
3. Stop it with `kill -STOP` and print its state (should be `T`). Small detail: signals are
   asynchronous; `sleep 0.2` before reading the state.
4. Resume it with `kill -CONT` and print its state again.
5. Kill it with `SIGKILL`, `wait` for it and print the exit status.

---
Write your solution in `answer.sh`, then run `check 1204`.  
To experiment with the same test files the checker uses: `play 1204`.
