# 1549 · Quick refresher: while

**Topic:** Loops: for, while, until, read · **Difficulty:** ★☆☆☆☆ · **Commands:** while

A `while` loop repeats its commands as long as its condition is true. Remember to change the variable inside the loop, or it never ends.

The script receives a number N. Print a countdown from N down to 1, one number per line, using a `while` loop.

Example: run as `./script.sh 3` it prints:

```
3
2
1
```

Hint: start with `i=$1`, loop `while [ "$i" -ge 1 ]`, and inside the loop print `$i` and then lower it with `i=$((i - 1))`.

---
Write your solution in `answer.sh`, then run `check 1549`.  
To experiment with the same test files the checker uses: `play 1549`.
