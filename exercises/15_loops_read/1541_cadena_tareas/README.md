# 1541 · break and continue with a real stop condition

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** while read, case, break, continue

`tareas.txt` has lines `NOMBRE ESTADO`, ESTADO being `pendiente`, `hecho` or `fallo`. Process the
lines **in order** with a `while read` loop and a `case`:

- `hecho`: skip it (`continue`), it counts for nothing.
- `fallo`: print `parada en: NOMBRE` and **stop reading the rest of the file** (`break`) — no line
  after it is processed, not even other `fallo` or `pendiente` lines.
- `pendiente`: print `procesando: NOMBRE` and count it.

If the loop reaches the end of the file without ever meeting a `fallo` line, print `todo ok` instead
of the stop message. In both cases, finally print `procesadas: N` (N = the count of `pendiente`
lines actually printed).
