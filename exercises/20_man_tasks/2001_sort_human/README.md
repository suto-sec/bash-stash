# 2001 · Sizes with units, smallest first

**Topic:** Man page tasks · **Difficulty:** ★★☆☆☆ · **Commands:** sort

`sizes.txt` has one entry per line: a size (a number with an optional `K`, `M` or `G` suffix) and a name.

Print the lines ordered from the smallest size to the largest, keeping each line as it is. `512` is smaller than `3K`, and `3K` is smaller than `2M`, even though `3` comes after `2` and `512` after `3`.

Example: the lines `2M disk`, `512 log`, `3K cache` must come out as `512 log`, `3K cache`, `2M disk`.

`sort` has an option for exactly this kind of number: look it up in the manual (`man sort`) instead of converting anything yourself.
