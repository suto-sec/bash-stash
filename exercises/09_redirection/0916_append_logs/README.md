# 0916 · Appending both streams to logs

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★☆☆ · **Commands:** 2>>, tee -a, wc -l <

The provided `./job.sh NAME` prints some lines on stdout and, sometimes, some on stderr.
Run `./job.sh` once for each task name in `tareas.txt` (one per line, in order), so that:

- the **stdout** of all runs is **appended** to `run.log` and **also shown** on the screen (`tee -a`)
- the **stderr** of all runs is **appended** to `err.log` and **not** shown

`run.log` and `err.log` may already exist with older content: keep it. Finally print
`errors: <N>`, where N is the number of lines **added** to `err.log` by this execution.

---
Write your solution in `answer.sh`, then run `check 0916`.  
To experiment with the same test files the checker uses: `play 0916`.
