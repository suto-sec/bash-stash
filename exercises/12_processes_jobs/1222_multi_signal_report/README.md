# 1222 · multi_signal_report.sh (comma-separated signal list)

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** kill -s, IFS, read -ra, &, wait, case

Write `multi_signal_report.sh SIGLIST`, where `SIGLIST` is a **single argument**: one to four signal
names separated by commas (e.g. `TERM,KILL,HUP`), each one of `TERM KILL HUP USR1 USR2` (the signals
that reliably terminate a background `sleep`).

For each signal in `SIGLIST`, in order: start a fresh `sleep 300` in the background, send it that
signal, `wait` for it and print `SIGNAL: exit CODE`. Finally print `signals: <count>` and
`sum: <sum of all exit codes>`.

- Not exactly 1 argument: usage on stderr, exit **1**.
- Fewer than 1 or more than 4 signals in the list: error, exit **2**.
- A name in the list that is not one of the five allowed signals (including an empty name, e.g. from
  `TERM,,KILL`): error naming it, exit **3**.
