# 1550 · Quick refresher: read

**Topic:** Loops: for, while, until, read · **Difficulty:** ★☆☆☆☆ · **Commands:** read

`read VAR` reads one line from the standard input (what arrives into the script, normally typed on the keyboard) and stores it in `VAR`.

Read one line and print it with `you said: ` in front.

Example: if the input line is `hola mundo`, the output is:

```
you said: hola mundo
```

Hint: `read line`, then `echo "you said: $line"`.

---
Write your solution in `answer.sh`, then run `check 1550`.  
To experiment with the same test files the checker uses: `play 1550`.
