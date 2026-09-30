# 1436 · Classifying the signs of three numbers

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** test -lt -gt, case

The script receives exactly three integers. For each one print its sign as `+`, `-` or `0` (one line
each, in order). Then, using a single `case` on the three signs joined together (e.g. `+-0`), print
exactly one of:

- `con ceros` if at least one of the three is `0` (check this **first**, before any of the following)
- `todos positivos` if all three are `+`
- `todos negativos` if all three are `-`
- `mixto` otherwise (a mix of `+` and `-`, no zero)

---
Write your solution in `answer.sh`, then run `check 1436`.  
To experiment with the same test files the checker uses: `play 1436`.
