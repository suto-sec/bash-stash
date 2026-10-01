# 0127 · Command substitution $( )

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** $(...)

`$(command)` is replaced by whatever the command prints (its output).

1. Run `whoami` inside `$( )` and store what it prints in a variable called `WHO`: `WHO=$(whoami)`
2. Print `Soy ` followed by the value of `WHO`.

When the checker runs your script, the user is called `alumno`:

```
Soy alumno
```

Hint: `VAR=$(command)` stores the output of the command in `VAR`.

---
Write your solution in `answer.sh`, then run `check 0127`.  
To experiment with the same test files the checker uses: `play 0127`.
