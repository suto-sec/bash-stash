# 0112 · Quoting preserves spaces

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★☆☆☆ · **Commands:** quoting, variables

The file `msg.txt` contains one line with words separated by **several** spaces
(e.g. `hello     big    world`).

Print the line twice: first **exactly as it is** (spaces preserved), then with the words
separated by a **single** space. Read it into a variable with `MSG=$(cat msg.txt)` and play with quotes.

```
hello     big    world
hello big world
```

---
Write your solution in `answer.sh`, then run `check 0112`.  
To experiment with the same test files the checker uses: `play 0112`.
