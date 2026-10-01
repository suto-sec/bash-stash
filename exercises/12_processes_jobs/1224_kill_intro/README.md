# 1224 · kill: terminating a background process

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** kill, wait

`kill PID` asks a process to end (it sends the signal SIGTERM). `wait PID` waits for a background process to finish; afterwards `$?` holds the exit status of that process. A process ended by SIGTERM has the exit status `143`.

1. Start `sleep 300` in the background and save its PID (`PID=$!`).
2. End it with `kill "$PID"`.
3. Wait for it with `wait "$PID"`.
4. Print the exit status with `echo $?`.

Expected output:

```
143
```
