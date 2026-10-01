Write `table.sh N`. It prints the multiplication table of `N` from 1 to 10, one line each:

```
table.sh 7   ->   7 x 1 = 7
                  7 x 2 = 14
                  ...
                  7 x 10 = 70
```

`for i in 1 2 3 4 5 6 7 8 9 10` (or `{1..10}`) and `$(( N * i ))` do the work.
