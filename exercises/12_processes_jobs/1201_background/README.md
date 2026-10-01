# 1201 · Background processes, $! and wait

**Topic:** Processes, jobs & signals · **Difficulty:** ★★☆☆☆ · **Commands:** &, $!, kill, wait

1. Start `sleep 300` in the **background** and save its PID (`$!`).
2. Print `running` if the process exists (`kill -0 PID` succeeds), `not running` otherwise.
3. Terminate it with `kill` (default signal, SIGTERM).
4. `wait` for it and print the exit status returned by `wait` (a process killed by signal N exits
   with 128+N).
5. Print `running`/`not running` again.
