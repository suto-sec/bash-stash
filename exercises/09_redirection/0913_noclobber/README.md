# 0913 · Protecting files: noclobber and >

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★☆☆ · **Commands:** set -o noclobber, >|, { ...; } 2>/dev/null

`lista.txt` contains file names, one per line (they may contain spaces). Some of those files already
exist. Write a script that:

1. turns on `noclobber` (`set -o noclobber`), so that `>` refuses to overwrite existing files
2. for each name in `lista.txt`, tries to write the line `generated` into it **with `>`**, and prints
   `<name>: created` if the redirection worked or `<name>: kept` if it was refused.
   Decide it from the **exit status** of the redirection, not by testing whether the file exists.
   The shell's own error message must **not** appear anywhere (your stderr must be empty).
   Careful: in `cmd > file 2>/dev/null` the failing `> file` is processed *before* `2>/dev/null`...
3. overwrites the existing `forzar.txt` with the line `forced` anyway, using `>|`, and prints `forced`

Existing files must keep their content.
