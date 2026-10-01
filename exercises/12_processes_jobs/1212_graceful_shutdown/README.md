# 1212 · SIGTERM trap vs. SIGKILL

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** &, kill, kill -9, wait, $!, trap (in the provided script)

The provided `cleanup.sh FLAGFILE` traps `SIGTERM`: on that signal it writes `done` into `FLAGFILE` and
exits cleanly. It does **not** react specially to `SIGKILL` (a signal that can never be trapped).

1. Start `./cleanup.sh a.flag` in the background, `sleep 0.2` (let the trap install), send it the
   default signal (`kill`, i.e. SIGTERM), `wait` for it (hide messages) and print its exit status.
2. Print the content of `a.flag`.
3. Start `./cleanup.sh b.flag` in the background, `sleep 0.2`, send it `SIGKILL` (`kill -9`), `wait`
   for it (hide messages) and print its exit status.
4. Print `exists` or `missing` depending on whether `b.flag` was created.
