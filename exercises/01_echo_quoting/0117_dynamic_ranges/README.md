# 0117 · Ranges whose limit is a variable

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★☆☆ · **Commands:** seq, seq -f, seq -s, printf, $( )

The file `n.txt` contains a number N (between 3 and 15). Brace expansion **cannot** use variables
(`{1..$N}` stays literally `{1..5}`: braces are expanded **before** variables), so use `seq` and/or
`printf` to print these four lines (example for N = 5):

```
part1 part2 part3 part4 part5
img_001.png img_002.png img_003.png img_004.png img_005.png
5 3 1
1+2+3+4+5=15
```

1. `partI` for I from 1 to N, separated by one space
2. `img_III.png` with I zero-padded to 3 digits, from 1 to N, separated by one space
3. from N **down** to 1 in steps of 2, separated by one space (for N = 6: `6 4 2`)
4. the numbers from 1 to N joined with `+`, then `=` and their sum

No loops (`for`, `while`) allowed.
