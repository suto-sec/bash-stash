# 1334 · retry_cmd.sh: retrying a command up to N times

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** shift, $?, while, exit

Write `retry_cmd.sh N CMD [ARGS...]`: run `CMD ARGS...` (hiding its stdout and stderr) up to **N**
times, stopping as soon as one attempt succeeds. For every attempt actually run, print
`intento K: exit E` (E = its exit code). Afterwards:

- if some attempt succeeded, print `resultado: exito en el intento K` (K = the first successful one)
  and exit 0
- if none did, print `resultado: fallo tras N intentos` and exit with the exit code of the **last**
  attempt

If fewer than 2 arguments are given, or N is not a positive integer, print a usage message on stderr
and exit 1 (without attempting anything).
