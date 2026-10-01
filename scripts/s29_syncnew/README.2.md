Copy a file only if it **does not exist** in `DST` or the one in `SRC` is **newer** (`[[ $src -nt $dst ]]`); otherwise skip it silently. (`alpha.txt` is older in `dst`, `bravo.txt` is newer there.)
