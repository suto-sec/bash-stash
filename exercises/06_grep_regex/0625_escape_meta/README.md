# 0625 · Matching metacharacters literally

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -E, \$ \. \( \[, grep -F

`precios.txt` mixes prices, formulas and status marks. Print, separated by `---`, the lines that contain:

1. a **price**: a `$`, one or more digits, a `.`, exactly two digits, and then either the end of the
   line or a character that is not a digit (`$12.50` yes; `$1.5`, `$3.999`, `$12,50`, `12.50$` no)
2. the literal text `f(x)`
3. the literal text `[ok]` (exact case)

Remember which characters are special in a regex (`$ . ( ) [ ] *`) and how to escape them
(or when `grep -F` is enough).
