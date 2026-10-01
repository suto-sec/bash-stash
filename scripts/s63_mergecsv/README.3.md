With `-u` as the **first** argument, a data row that appeared before (in either file) is printed only the **first** time, keeping the original order (the repeated `3,eva`). `-u` alone or with one file is the usage error.

An associative array remembers the rows seen: `[[ -z ${seen[$row]} ]] && { seen[$row]=1; echo "$row"; }`.
