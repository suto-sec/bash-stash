# 0125 · Single vs double quotes

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** ', ", $VAR

Single quotes print text exactly as written; inside double quotes the shell replaces `$NOMBRE` by the value of the variable.

1. Write this line at the top of your script: `NOMBRE=Kernel`
2. Print the first line below with **single** quotes, so `$NOMBRE` appears literally, and the second line with **double** quotes, so `$NOMBRE` is replaced by `Kernel`. Use the variable in both lines, do not type `Kernel` in the second one.

```
Hola $NOMBRE
Hola Kernel
```

Hint: `echo 'text $VAR'` prints `$VAR` as it is; `echo "text $VAR"` prints its value.

---
Write your solution in `answer.sh`, then run `check 0125`.  
To experiment with the same test files the checker uses: `play 0125`.
