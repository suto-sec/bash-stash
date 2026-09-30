# 1218 · signal_sender.sh (signal name to N processes)

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** kill -s, &, wait, case, exit codes

Write `signal_sender.sh SIGNAL COUNT`. It starts `COUNT` background `sleep 300` jobs (in order), sends
each of them signal `SIGNAL`, then `wait`s for all of them **in start order**, printing
`job i: exit CODE` for each (`i` = 1..COUNT), and finally `sum: <sum of the COUNT exit codes>`.

`SIGNAL` must be one of `TERM KILL HUP USR1 USR2` (all of which terminate a `sleep`; note that `INT`
and `QUIT` are silently ignored by background jobs started from a script, so they are not offered
here).

- Not exactly 2 arguments: usage on stderr, exit **1**.
- `SIGNAL` not one of the five listed above: error naming it, exit **2**.
- `COUNT` not an integer: error, exit **3**.
- `COUNT` outside `1..5`: error, exit **4**.

---
Write your solution in `answer.sh`, then run `check 1218`.  
To experiment with the same test files the checker uses: `play 1218`.
