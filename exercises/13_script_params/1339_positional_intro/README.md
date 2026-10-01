# 1339 · $1, $2 and $#

**Topic:** Script parameters & exit codes · **Difficulty:** ★☆☆☆☆ · **Commands:** $1, $2, $#

The words you type after the script name are its arguments: inside the script `$1` is the first one, `$2` the second one and `$#` is how many there are.

The checker runs your script with no arguments, with one, with two and with three. Print three lines with the value of `$1`, the value of `$2` and the value of `$#`. If an argument is missing its value is simply empty, but the line is still printed.

Example: run as `./script.sh uno dos` it prints:

```
Primero: uno
Segundo: dos
Total: 2
```

Hint: `echo "Primero: $1"`

---
Write your solution in `answer.sh`, then run `check 1339`.  
To experiment with the same test files the checker uses: `play 1339`.
