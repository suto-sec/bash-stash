# 0126 · $VAR and ${VAR}

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** $VAR, ${VAR}

Written as `$CURSO2026`, the shell would look for a variable called `CURSO2026`, which does not exist. Braces mark where the name ends: `${CURSO}2026`.

1. Write this line at the top of your script: `CURSO=so`
2. Print the value of `CURSO` immediately followed by the text `2026`, using `${CURSO}`:

```
so2026
```

Hint: `echo "${NAME}text"`
