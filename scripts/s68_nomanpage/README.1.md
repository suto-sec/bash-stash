In the lab the manual pages of section 1 live in files called `NAME.1.gz` (for `ls`: `ls.1.gz`) inside one directory. Write `nomanpage.sh BINDIR MANDIR`. It prints, one per line and **sorted**, the name of every entry of `BINDIR` that has **no** file `MANDIR/NAME.1.gz`. Names may contain spaces and dots.

Example: if `bin` holds `ls cat tool` and `man` holds `ls.1.gz cat.1.gz`, the output is `tool`.
