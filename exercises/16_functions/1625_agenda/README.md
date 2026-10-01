# 1625 · agenda.sh: a subcommand dispatcher built from functions

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** die/usage pattern, case, shift, "$@" forwarding

Write `agenda.sh COMANDO [ARGS...]`, keeping contacts in `agenda.txt` (lines `NOMBRE:TELEFONO`).
Write a helper `die CODE MESSAGE...` (prints `ERROR: MESSAGE` on stderr, exits with CODE) and one
function per subcommand, each validating its own argument count with `die`:

- `listar` (0 args): print every contact as `NOMBRE: TELEFONO`, sorted (`sort agenda.txt`), or
  `agenda vacia` if the file is missing/empty.
- `buscar NOMBRE` (1 arg): print `NOMBRE: TELEFONO` for every matching line (a line whose name is
  exactly NOMBRE, i.e. it starts with `NOMBRE:`), or `no encontrado` if none.
- `borrar NOMBRE` (1 arg): delete every matching line (same rule) (`sed -i`) and print `borrados: K` (K = how
  many).
- `add NOMBRE TELEFONO` (2 args): TELEFONO must be digits only (die otherwise, naming it); append
  the line and print `agregado: NOMBRE`.

The script itself only does `[ $# -ge 1 ] || die 1 ...`, then `comando=$1; shift` and dispatches
with a `case` that forwards the rest with `"$@"`.

Exit codes: 1 no COMANDO at all; 2 unknown COMANDO (name it); 3 wrong number of arguments for the
given COMANDO; 4 `add` with a non-numeric TELEFONO (name it).
