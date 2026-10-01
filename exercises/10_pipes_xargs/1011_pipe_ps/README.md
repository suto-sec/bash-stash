# 1011 · Processes in a pipeline

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** ps -e -o, grep, sort, uniq -c

Print the users that own processes in the system, with how many processes each owns, in
`uniq -c` format, sorted by user name. Use `ps -e -o user=` (the `=` removes the header).

Note: your own script and its pipeline also count as processes of `alumno`; the checker
tolerates that difference only if your pipeline is a single line... so keep it on **one line**.
