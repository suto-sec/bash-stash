# 0122 · echo: print a line, echo -n

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** echo, echo -n

Practise `echo` and its `-n` option, which leaves out the final newline.

1. Print the line `Listo`.
2. Print `Sin salto` **without** a newline (`echo -n`), then print `!` with a normal `echo`, so both end up on the same line.

Expected output:

```
Listo
Sin salto!
```

Hint: `echo text` prints the text and a newline; `echo -n text` prints it without the newline.

---
Write your solution in `answer.sh`, then run `check 0122`.  
To experiment with the same test files the checker uses: `play 0122`.
