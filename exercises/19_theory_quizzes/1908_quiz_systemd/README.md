# 1908 · systemd, services & shutdown

**Topic:** Theory quizzes · **Difficulty:** ★★★☆☆ · **Commands:** systemctl, targets, shutdown

Answer in `answer.txt` as `N: answer`.

1. First target systemd starts. (name)
2. Target that `default.target` usually links to on a desktop. (name)
3. Target of runlevel 1 (single user). (name)
4. Target of runlevel 0. (name)
5. Target of runlevel 6. (name)
6. Target of runlevel 3. (name)
7. Command to show the default target. (command)
8. `systemctl` subcommand to switch to another target right now. (subcommand)
9. Command to start the service `cups` now. (command)
10. Command to make `cups` start at every boot. (command)
11. Kernel mechanism systemd uses to track processes instead of PIDs. (name)
12. Command to power off **now**. (with `shutdown`)
13. Command to cancel a scheduled shutdown. (command)
14. Signal sent first to every process during shutdown. (name)
15. Seconds after which the remaining processes receive `SIGKILL`. (number)
16. Name of the classic init system systemd replaced on Linux. (name)
17. What is a systemd **unit**? a) a CPU core b) a configuration file describing something systemd
    manages (a service, a mount...) c) a user session (a/b/c)

---
Write your answers in `answer.txt` (one `N: answer` line per question), then run `check 1908`.
