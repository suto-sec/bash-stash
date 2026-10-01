# 1415 · Classifying a triangle

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** test -eq -le, if elif, &&, ||

Write `triangle.sh a b c`, where `a`, `b`, `c` are the lengths of three sides (non-negative integers
written with digits only). Print exactly one line:

- `not a triangle` if some side is 0 or some side is **greater than or equal to** the sum of the
  other two; in this case exit with code **2**
- otherwise `equilateral` (3 equal sides), `isosceles` (exactly 2 equal) or `scalene` (all different),
  followed by ` right` if it is a right triangle (the square of one side equals the sum of the squares
  of the other two), e.g. `scalene right`; exit **0**

If there are not exactly 3 arguments or one of them is not made of digits only, print
`Usage: triangle.sh a b c` on **stderr** (use `$(basename "$0")`) and exit **1**.
