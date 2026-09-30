# 0126 · $VAR and ${VAR}

**Topic:** Echo, quoting & substitution · **Difficulty:** ★☆☆☆☆ · **Commands:** $VAR, ${VAR}

Set `CURSO=so`, then print `so2026` by concatenating `$CURSO` with the literal `2026`,
using `${CURSO}` so the shell doesn't look for a variable named `CURSO2026`:

```
so2026
```

---
Write your solution in `answer.sh`, then run `check 0126`.  
To experiment with the same test files the checker uses: `play 0126`.
