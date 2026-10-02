`$PATH` is a list of directories separated by `:`. Write `inpath.sh NAME LIST`, where `LIST` is such a list (in the checks: `bin1:bin2:bin3`). It prints, **in the order of the list**, every directory of `LIST` that contains a **regular file** called `NAME`. Directories that do not exist are simply skipped.

`echo "$LIST" | tr ':' '\n'` gives one directory per line.
