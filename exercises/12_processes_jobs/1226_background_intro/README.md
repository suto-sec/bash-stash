# 1226 · &: running a command in the background

**Topic:** Processes, jobs & signals · **Difficulty:** ★☆☆☆☆ · **Commands:** &, $!, wait

Ending a command with `&` runs it in the background: the shell does not wait and goes on with the next line. `$!` holds the PID of the last background command and `wait PID` waits for it to finish.

1. Start `sleep 0.2` in the background (`&`) and save its PID (`PID=$!`).
2. Print `launched` right away.
3. Wait for the process with `wait "$PID"`.
4. Print `done`.

Expected output:

```
launched
done
```
