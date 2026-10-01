# 1906 · Processes & signals

**Topic:** Theory quizzes · **Difficulty:** ★★☆☆☆ · **Commands:** ps, kill, top, pstree

Answer in `answer.txt` as `N: answer`.

1. Maximum PID in classic 16-bit Unix compatibility. (number)
2. PID of the initial process (`init`/`systemd`). (number)
3. PID of the "idle" process. (number)
4. Number of `SIGKILL`. (number)
5. Number of the signal `kill` sends by default (`SIGTERM`). (number)
6. `ps` state letter of a **zombie** process. (letter)
7. `ps` state letter of a process stopped with Ctrl+Z. (letter)
8. `ps` state letter of a **running** process. (letter)
9. `ps` option (UNIX style, with dash) to list **every** process. (option)
10. Command that shows the processes as a tree. (command)
11. Exit status seen by the shell for a process killed with `SIGKILL`. (number)
12. What are daemons? a) interactive processes b) processes that do system tasks in the background
    c) zombie processes (a/b/c)
13. Can a process ignore `SIGKILL`? (yes/no)
14. Signal sent by Ctrl+C (name without `SIG`). (name)
15. `kill -0 PID` sends no signal: what is it used for? a) to kill quietly b) to check whether the
    process exists (and we may signal it) c) to pause it (a/b/c)
