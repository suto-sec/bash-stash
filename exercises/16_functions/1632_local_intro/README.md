# 1632 · Quick refresher: local

**Topic:** Functions · **Difficulty:** ★☆☆☆☆ · **Commands:** local

A variable declared `local` inside a function exists only while the function runs; it does not change a variable with the same name outside.

1. Set `X=fuera` and print it.
2. Define a function `f` that declares `local X=dentro` and prints `$X`. Call `f`.
3. Print `$X` again: it must still be `fuera`.

Expected output:

```
fuera
dentro
fuera
```

Hint: `f() { local X=dentro; echo "$X"; }`

---
Write your solution in `answer.sh`, then run `check 1632`.  
To experiment with the same test files the checker uses: `play 1632`.
