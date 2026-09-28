# 1210 · Waiting for a condition

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** while, sleep, kill -0, &

The provided `worker.sh` runs for a random time (under 2 s) and creates `done.flag` when it finishes.
Start it in the background and **poll** every 0.1 s until `done.flag` exists (or at most 50 times).
Then print `worker finished` and the content of `done.flag`. The script must exit 0.

---
Write your solution in `answer.sh`, then run `check 1210`.  
To experiment with the same test files the checker uses: `play 1210`.
