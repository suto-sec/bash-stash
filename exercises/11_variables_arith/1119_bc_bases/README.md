# 1119 · Base conversion with bc's ibase/obase

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** bc, ibase, obase

The file `n.txt` contains a decimal integer N, and `base.txt` a target base B (2-16; digits above 9 are
written as `A`-`F`). The file `digits.txt` contains a number already written in base B. Using **`bc`**
with `ibase`/`obase` (not `$(( ))`), print:

1. N written in base B (`obase=B; N`)
2. the decimal value of the number in `digits.txt`, which is written in base B (`ibase=B; ...`)
