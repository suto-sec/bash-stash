Write `vowels.sh TEXT`. It prints how many vowels (`a e i o u`, upper or lower case) the text has: `vowels.sh Banana` prints `3`.

`tr -cd 'aeiouAEIOU'` keeps only the vowels (`-d` deletes, `-c` complements the set) and `wc -c` counts what is left. The text may contain spaces when quoted.
