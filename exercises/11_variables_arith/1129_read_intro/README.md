# 1129 · read: loading a line into a variable

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★☆☆☆☆ · **Commands:** read

`read VAR` reads one line and stores it in the variable `VAR`.

The file `dato.txt` contains a single line of text.

1. Read that line into a variable called `X`, taking it from the file with `<`: `read X < dato.txt`
2. Print `Leido: ` followed by the value of `X`.

Example: if `dato.txt` contains `manzana`, the output is:

```
Leido: manzana
```

---
Write your solution in `answer.sh`, then run `check 1129`.  
To experiment with the same test files the checker uses: `play 1129`.
