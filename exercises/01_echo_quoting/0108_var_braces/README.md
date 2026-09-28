# 0108 · Variables and ${...}

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★☆☆☆ · **Commands:** variables, ${VAR}, cat

The file `name.txt` (in the current directory) contains a single word, e.g. `kernel`.

1. Store its content in a variable called `NAME`.
2. Print `NAME_backup.tar`, e.g. `kernel_backup.tar`
3. Print `NAMEs are cool`, e.g. `kernels are cool`

```
kernel_backup.tar
kernels are cool
```

Hint: `$NAME_backup` is a different (empty) variable. Use `${NAME}`.

---
Write your solution in `answer.sh`, then run `check 0108`.  
To experiment with the same test files the checker uses: `play 0108`.
