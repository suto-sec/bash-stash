# 1331 · Counting a repeatable flag among positionals

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** case, for, "$@", $#

The script receives a mix of the literal flag `-v` and file names, in any order (the flag may repeat
or not appear at all). Using a `for`/`case` loop over `"$@"` (not `getopts`), separate the flags from
the file names:

- for every non-flag argument, in order, print `archivo: NAME`
- ignore (do not print) the `-v` occurrences themselves

Finally print `verbosidad: V, archivos: M` (V = number of times `-v` appeared, M = number of file
names). With no arguments at all, print only `verbosidad: 0, archivos: 0`.
