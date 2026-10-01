# 1416 · Comparing version numbers

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** [[ =~ ]], IFS=. read, test -lt -gt -ne

Write `vercmp.sh v1 v2`. A version is `MAJOR.MINOR.PATCH`: three non-negative integers (digits only)
separated by dots. Compare them **numerically**, part by part from left to right (so `1.10.0` is
greater than `1.9.9`), and print one line: `v1 < v2`, `v1 = v2` or `v1 > v2` (with the versions
as given).

Errors (stderr, exact text): not exactly 2 arguments → `Usage: vercmp.sh v1 v2` (use
`$(basename "$0")`), exit **1**; a version with the wrong format → `Invalid version: <v>` (the first
invalid one), exit **2**.
