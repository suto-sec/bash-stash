Write `countdown.sh N`. It prints the numbers from `N` down to 1, one per line, and then `Liftoff!`.

```
countdown.sh 3   ->   3
                      2
                      1
                      Liftoff!
```

`while (( n > 0 )); do ...; n=$((n - 1)); done` is the loop to use.
