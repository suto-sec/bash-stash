# 2005 · Newer than a reference file

**Topic:** Man page tasks · **Difficulty:** ★★★☆☆ · **Commands:** find

The folder `informes` holds regular files (some inside subfolders) and next to it there is a file called `referencia`.

Print the path of every regular file under `informes` that was modified **more recently than `referencia`**, one per line, in alphabetical order.

Example: if `informes/a` is older than `referencia` and `informes/sub/b` is newer, the output is `informes/sub/b`.

`find` can compare a file's modification time with another file's: look for it in `man find` (the TESTS section).
