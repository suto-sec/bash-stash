# 2008 · Only the repeated lines

**Topic:** Man page tasks · **Difficulty:** ★★★☆☆ · **Commands:** sort, uniq

`nombres.txt` has one name per line, in no particular order, and some names appear more than once.

Print the names that appear **more than once**, each of them **a single time**, in alphabetical order.

Example: for `ana`, `luis`, `ana`, `eva`, `luis`, `ana` the output is `ana` and `luis`.

`uniq` only compares neighbouring lines, so sort first. One of its options keeps only the repeated lines: `man uniq`.
