# 1108 · seq and bc

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★☆☆☆ · **Commands:** seq, seq -s, bc

The file `n.txt` contains a number N. Print:

1. the numbers from 1 to N in one line separated by spaces (`seq -s ' '`)
2. the even numbers from 2 to 2·N, one per line (`seq` with increment)
3. the sum 1+2+...+N computed with `seq -s+ 1 N | bc`
4. the same sum with the formula `N*(N+1)/2` in `$(( ))`
