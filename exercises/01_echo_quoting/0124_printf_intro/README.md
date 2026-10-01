# 0124 · printf: a basic format string

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** printf

`printf` prints exactly what its format string says. Unlike `echo` it does **not** add a newline: you write `\n` yourself. Each `%s` in the format is replaced by the next argument.

1. Write these two lines at the top of your script:
   ```
   nombre=Ana
   edad=23
   ```
2. Use **one** `printf` (no `echo`) to print the line below. It must end with a newline.

```
Ana tiene 23 anios
```

Hint: `printf '%s is %s\n' "$first" "$second"`
