# 1518 · Retrying a command

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** until, $?, counters

`flaky.sh` fails (exit 1) several times before succeeding (it keeps a counter in `.flaky_state`).
Run it until it succeeds, **at most 5 attempts**. For each attempt print `attempt N: exit C`.
At the end print `success after N attempts` or `giving up after 5 attempts` and exit 0 or 1 accordingly.

---
Write your solution in `answer.sh`, then run `check 1518`.  
To experiment with the same test files the checker uses: `play 1518`.
