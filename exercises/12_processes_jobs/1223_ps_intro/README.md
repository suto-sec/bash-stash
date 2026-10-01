# 1223 · ps: checking a process exists

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** ps -p

`ps -p PID` succeeds (exit status 0) if a process with that PID exists, and fails if it does not.

1. Start `sleep 300` in the background (add `&` at the end of the line) and save its PID with `PID=$!` (`$!` is the PID of the last background command).
2. If `ps -p "$PID" > /dev/null` succeeds print `found`, otherwise print `not found` (`> /dev/null` hides the table that `ps` prints).
3. Kill the process with `kill "$PID"` so it does not keep running.

Expected output:

```
found
```

Hint: `if COMMAND; then echo one; else echo two; fi`

---
Write your solution in `answer.sh`, then run `check 1223`.  
To experiment with the same test files the checker uses: `play 1223`.
