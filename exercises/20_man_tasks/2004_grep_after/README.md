# 2004 · Matches and what follows them

**Topic:** Man page tasks · **Difficulty:** ★★☆☆☆ · **Commands:** grep

`servicio.log` has lines of several kinds; some contain the word `ERROR`.

Print every line that contains `ERROR` **together with the two lines that come after it**. Leave grep's own output as it is, including the `--` lines it prints between separate groups.

Example: if line 3 is the only `ERROR`, the output is lines 3, 4 and 5.

`grep` can print context around the lines it finds: see "Context Line Control" in `man grep`.
