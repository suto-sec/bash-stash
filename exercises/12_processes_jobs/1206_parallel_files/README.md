# 1206 · Parallel work

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★☆☆ · **Commands:** &, wait

For each `.txt` file in `datos` (sorted), start **in the background** a job that counts its lines and
writes the number into `resultados/<name>.count` (e.g. `resultados/a.txt.count`). Wait for **all**
jobs to finish and then print the total number of lines (sum of all `.count` files).
