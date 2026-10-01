# 0345 · basename and dirname

**Topic:** Files, copies & links · **Difficulty:** ★☆☆☆☆ · **Commands:** basename, dirname

`basename` prints the last part of a path (the file name); `dirname` prints everything before it (the folder).

1. Write this line at the top of your script: `P=/home/alumno/datos/informe.txt`
2. Print the file name of `$P` with `basename`, and then its folder with `dirname`:

```
informe.txt
/home/alumno/datos
```

Hint: `basename "$P"` and `dirname "$P"`

---
Write your solution in `answer.sh`, then run `check 0345`.  
To experiment with the same test files the checker uses: `play 0345`.
