Write `iplog.sh PATH IP`. It looks at the **log files directly inside `PATH`** (regular files whose name ends in `.log`; not the subdirectories, not other extensions) and prints `NAME: N` for every one that contains the address on at least one line, where `NAME` is the file name without the directory and `N` is the number of lines with the address. Files in the order `ls` lists them; files without the address print nothing.

The address must match **as a whole**: `10.0.0.5` is not in `10.0.0.50` (`grep -c -w -F`).
