# 1221 · supervise.sh (retry until success)

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** &, wait, $!, while/for, exit codes

The provided `worker.sh` simulates a flaky task: a counter `remaining_fails` starts at a random small
number `F` (0 to 3, fixed for the whole run). Each time `worker.sh` runs, it decrements the counter and
exits **1** while it is still positive, or exits **0** once it has reached zero.

Write `supervise.sh MAX_RESTARTS`. It runs `./worker.sh` in the background and `wait`s for it, printing
`attempt N: exit CODE` (`N` starting at 1). If the exit code was **0**, print `succeeded after N
attempts` and exit **0**. Otherwise, if `N` has not yet reached `MAX_RESTARTS`, run it again (attempt
`N+1`); if `N` reaches `MAX_RESTARTS` without ever succeeding, print `gave up after N attempts` and
exit **10**.

- Not exactly 1 argument: usage on stderr, exit **1**.
- `MAX_RESTARTS` not an integer: error, exit **2**.
- `MAX_RESTARTS` outside `1..5`: error, exit **3**.
