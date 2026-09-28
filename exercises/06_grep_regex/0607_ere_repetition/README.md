# 0607 · Repetition: * + ? {n,m}

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -E, + ? {n,m}

The file `codigos.txt` contains one code per line. Print separated by `---`:

1. the codes made of **exactly** 3 uppercase letters, a `-` and 2 to 4 digits (`ABC-12`, `XYZ-1234`)
2. the codes that contain **one or more** `x` followed by `y` (e.g. `xy`, `xxxy`)
3. the codes that are `colour` or `color` (optional `u`), exact whole line

---
Write your solution in `answer.sh`, then run `check 0607`.  
To experiment with the same test files the checker uses: `play 0607`.
