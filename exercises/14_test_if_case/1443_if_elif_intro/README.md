# 1443 · Quick refresher: if / elif / else

**Topic:** test, if & case · **Difficulty:** ★☆☆☆☆ · **Commands:** if, elif, else

`if` / `elif` / `else` runs the first block whose condition is true. To compare numbers use `-gt` (greater than), `-lt` (less than) and `-eq` (equal), for example `[ "$1" -gt 0 ]`.

The script receives one whole number. Print `positive` if it is greater than 0, `negative` if it is less than 0 and `zero` otherwise, using an `if` / `elif` / `else` chain.

Examples: `5` prints `positive`, `-3` prints `negative`, `0` prints `zero`.

Hint:

```
if [ "$1" -gt 0 ]; then
  echo ...
elif [ ... ]; then
  echo ...
else
  echo ...
fi
```

---
Write your solution in `answer.sh`, then run `check 1443`.  
To experiment with the same test files the checker uses: `play 1443`.
