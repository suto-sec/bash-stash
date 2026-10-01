Write `splitfile.sh FILE N`. It cuts `FILE` into parts of `N` lines each: `FILE.part1` has the lines 1 to N, `FILE.part2` the next N, and so on (the last part may be shorter). Print `Created FILE.partK` for each part. An empty file creates no parts. Assume no part exists yet (in this step the checker uses `three.txt` and `empty.txt`).

`sed -n "${a},${b}p" file` prints the lines `a` to `b`.
