# 1631 · Quick refresher: $1 inside a function

**Topic:** Functions · **Difficulty:** ★☆☆☆☆ · **Commands:** $1

Inside a function, `$1` is the **first argument of the function call** (not of the script).

Define a function `saluda` that prints `Hola, ` followed by its first argument and an exclamation mark, using `$1` inside it. Then call it once, passing the first argument of the script.

Example: run as `./script.sh Ana` it prints:

```
Hola, Ana!
```

Hint: `saluda() { echo "Hola, $1!"; }` and then `saluda "$1"`.
