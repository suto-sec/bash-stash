Write `backup2.sh SRC DST`. It copies **every regular file below `SRC`** (any depth) into the existing directory `DST`, keeping its path **relative to `SRC`** (`SRC/sub/b.txt` becomes `DST/sub/b.txt`; create the subdirectories as needed), and prints `copied REL` for each (REL is that relative path). A file that cannot be copied (unreadable) is silently left out. The order of the lines does not matter.

`rel=${f#"$1"/}` removes the `SRC/` prefix of a path found by `find "$1" -type f`; `mkdir -p "$2/$(dirname "$rel")"` creates the directory.
