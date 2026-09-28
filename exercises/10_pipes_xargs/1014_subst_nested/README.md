# 1014 · Nested command substitution

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** $( $( ) ), basename, dirname

The file `ruta.txt` contains the path of a file that exists under the current directory.
Using nested command substitution, print one line:

```
The file <name> is in <dirname> which contains <N> entries
```

where `<name>` is the basename, `<dirname>` the directory as written in `ruta.txt`, and `<N>` the
number of entries of that directory.

---
Write your solution in `answer.sh`, then run `check 1014`.  
To experiment with the same test files the checker uses: `play 1014`.
