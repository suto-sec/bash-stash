# 1216 · ps -o stat= across several PIDs at once

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** ps -o stat= -p, kill -STOP, kill -CONT, kill -9, grep -c

1. Start four background `sleep 300` jobs; save their PIDs.
2. Stop the 2nd and 4th (`kill -STOP`); `sleep 0.2`.
3. Using a **single** `ps -o stat= -p PID1,PID2,PID3,PID4` call, print how many are **running**
   (`grep -c '^S'`) and how many are **stopped** (`grep -c '^T'`), as `running: N` then `stopped: N`.
4. Resume the two stopped ones (`kill -CONT`); `sleep 0.2`; print the same two counts again.
5. Kill all four (`kill -9`) and `wait` for them (hide messages).
