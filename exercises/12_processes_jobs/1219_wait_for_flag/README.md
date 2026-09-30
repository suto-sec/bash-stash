# 1219 · wait_for_flag.sh (polling with a timeout)

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** &, while, sleep, kill -0, kill -9, wait

The provided `worker.sh` (no arguments) sleeps for a short, unknown amount of time and then creates
`done.flag` containing a line of text.

Write `wait_for_flag.sh POLL_TENTHS MAX_POLLS`. It starts `./worker.sh` in the background, then polls
for `done.flag` up to `MAX_POLLS` times, sleeping `POLL_TENTHS` **tenths of a second** between polls
(`sleep 0.<POLL_TENTHS>`).

- If `done.flag` appears within that budget: print `worker finished` and the content of `done.flag`,
  exit **0**.
- If it never appears: kill the worker (`kill -9`), `wait` for it (hide messages), print
  `Error: worker did not finish in time` on **stderr**, exit **4**.

- Not exactly 2 arguments: usage on stderr, exit **1**.
- `POLL_TENTHS` not a positive integer: error, exit **2**.
- `MAX_POLLS` not a positive integer: error, exit **3**.

---
Write your solution in `answer.sh`, then run `check 1219`.  
To experiment with the same test files the checker uses: `play 1219`.
