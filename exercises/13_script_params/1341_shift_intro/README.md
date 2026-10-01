# 1341 · shift

**Topic:** Script parameters & exit codes · **Difficulty:** ★☆☆☆☆ · **Commands:** shift

`shift` throws away the first argument: `$2` becomes `$1`, `$3` becomes `$2`, and `$#` goes down by one.

1. Print `Primero: ` followed by the value of `$1`.
2. Run `shift`.
3. If there is still an argument (`$#` is not 0), print `Ahora: ` followed by the new `$1`; otherwise print `none`.

Examples:

```
./script.sh uno dos      ./script.sh uno      ./script.sh
Primero: uno             Primero: uno         Primero:
Ahora: dos               none                 none
```

Hint: `if [ $# -eq 0 ]; then ...; else ...; fi`

---
Write your solution in `answer.sh`, then run `check 1341`.  
To experiment with the same test files the checker uses: `play 1341`.
