# 1205 · Exit statuses of background jobs

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** ( ) &, wait PID, $?

Start **in the background**, in this order, three subshells that end with different exit codes:

- `(sleep 0.3; exit 3) &`
- `(sleep 0.1; exit 0) &`
- `(sleep 0.2; exit 7) &`

Save their PIDs, then wait for each one **in the order they were started** and print
`job N: exit CODE` for each (N = 1, 2, 3). Finally print `total: SUM` with the sum of the three codes.
