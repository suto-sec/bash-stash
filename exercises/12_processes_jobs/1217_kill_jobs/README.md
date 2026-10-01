# 1217 · kill_jobs.sh (job-spec parsing)

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** &, kill %N, jobs, case, wait, exit codes

Write `kill_jobs.sh SPEC...`. The script itself always starts exactly **3** background jobs
(`sleep`, long enough to still be running afterwards), numbered 1 to 3 in the order they were started.
Each `SPEC` argument names which of those 3 are **targeted**: it is either a job number as `%1`, `%2`,
`%3`, or the literal `all` (meaning all three). A job may be targeted more than once.

The script applies every given `SPEC` (in any way you like) and then terminates **all 3** of its jobs
before finishing (so it never leaves anything running, whether a job was targeted or not). It prints,
for `job 1`, `job 2`, `job 3` in that order, one of:

```
job N: killed by spec
job N: not in spec
```

then a final `targeted: <count> of 3`.

- No `SPEC` given: usage message on stderr, exit **1**.
- A `SPEC` that is not `%1`, `%2`, `%3` or `all`: error naming the offending token, exit **2**.
