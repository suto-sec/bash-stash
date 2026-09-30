# 1213 · Signals a background job ignores

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** kill -INT, kill -QUIT, kill, kill -0, wait

A background job started from a non-interactive script **ignores** `SIGINT` and `SIGQUIT` (the
signals Ctrl+C and Ctrl+\ send); only signals like `SIGTERM` (or `SIGKILL`) actually terminate it.

1. Start `sleep 300` in the background.
2. Send it `SIGINT`, `sleep 0.3`, print `alive` or `dead` (`kill -0`).
3. Send it `SIGQUIT`, `sleep 0.3`, print `alive` or `dead`.
4. Send it the default signal (`kill`, i.e. SIGTERM), `sleep 0.3`, print `alive` or `dead`.
5. `wait` for it (hide messages) and print the exit status.

---
Write your solution in `answer.sh`, then run `check 1213`.  
To experiment with the same test files the checker uses: `play 1213`.
