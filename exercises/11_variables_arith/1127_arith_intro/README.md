# 1127 · Arithmetic with $(( ))

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★☆☆☆☆ · **Commands:** $(( ))

`$(( ))` calculates with whole numbers: `$((3 + 4))` is replaced by `7`. Inside it you can write variable names without the `$`.

1. Write these two lines at the top of your script: `A=6` and `B=7`
2. Print the result of `A * B` using `$(( ))`:

```
42
```

Hint: `echo $((A * B))`
