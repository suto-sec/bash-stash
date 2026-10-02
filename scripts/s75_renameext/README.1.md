Write `renameext.sh DIR OLD NEW`. In `DIR` (not below it) every **regular file** whose name ends in `.OLD` is renamed so that it ends in `.NEW` (`OLD` and `NEW` are given **without** the dot). For each one print `oldname -> newname` (names only, no directory); the order does not matter. A directory called `dir.txt`, `x.txt.bak` or `notes.markdown` are **not** renamed (name must end exactly in `.OLD`). Hidden files count like any other. Names may contain spaces.

Example: `renameext.sh docs txt md` turns `b.txt` into `b.md` and prints `b.txt -> b.md`. In this step assume the new name is free.
