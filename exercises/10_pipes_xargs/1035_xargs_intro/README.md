# 1035 · xargs: turning lines into arguments

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** xargs

`xargs` takes the words that arrive on its input and passes them as arguments to a command. Without a command it uses `echo`, so it joins all the words on a single line.

The file `nombres.txt` has one word per line. Print them all on one line, separated by spaces, by piping the file into `xargs`.

Example: if `nombres.txt` contains `ana`, `luis`, `eva` (one per line), the output is:

```
ana luis eva
```

Hint: `cat file | xargs`

---
Write your solution in `answer.sh`, then run `check 1035`.  
To experiment with the same test files the checker uses: `play 1035`.
