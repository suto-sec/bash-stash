# 1619 · informe.sh: a name collision that needs local

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** local, functions, scope

Write `informe.sh FILE...`. Loop over the arguments with `for f in "$@"; do revisar "$f"; done`
(the loop variable must be named `f`). `revisar` must:

- if FILE doesn't exist or isn't readable: print a message on stderr naming it (wording free) and
  count it as skipped — don't stop the script;
- otherwise read the file's first line into a **local** variable also named `f` (yes, on purpose —
  it must not leak into the caller's loop variable), and print
  `FILE: primera linea = 'f' (lineas: L)` (the quotes are literal; `f` stands for the text of that first line; L = `wc -l` of the file), counting it as ok.

After the loop, print `procesados: OK ok, SKIP saltados` and then `ultimo arg: $f` — this last line
must show the **last FILE argument itself**, proving the loop variable was never overwritten by
`revisar`.

Errors: no arguments at all → usage on stderr, exit 1.
