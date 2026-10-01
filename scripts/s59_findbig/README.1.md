Write `findbig.sh DIR`. It prints the **biggest regular file** below `DIR` (any depth) as `SIZE PATH` (size in bytes, then the path as `find` shows it). In the checker no two files have the same size at the top. Nothing is printed for a directory without files.

`find "$1" -type f -printf '%s %p\n' | sort -nr | head -n 1`.
