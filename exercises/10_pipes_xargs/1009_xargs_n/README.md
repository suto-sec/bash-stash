# 1009 · xargs -n and -I

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** xargs -n1, xargs -I{}

`dirs.txt` contains one directory name per line (no spaces). Using `xargs`:

1. create all those directories (`xargs mkdir -p`)
2. inside each one create a file called `README` (`xargs -I{} touch {}/README`)
3. print the numbers of `numeros.txt` (several per line) **two per line** (`xargs -n2`)

---
Write your solution in `answer.sh`, then run `check 1009`.  
To experiment with the same test files the checker uses: `play 1009`.
