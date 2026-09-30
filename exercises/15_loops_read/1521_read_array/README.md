# 1521 · Splitting a line into an array with read -a

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** read -ra, ${#arr[@]}, for

For every line of `frases.txt` (words separated by any amount of spaces or tabs) print:

```
N: W words, longest: WORD
```

where N is the line number, W the number of words and WORD the longest word (the first one of that
length if tied). Empty lines print `N: 0 words`. Finally print `total: T words`.

Use `read -ra words` to split each line into an array.

---
Write your solution in `answer.sh`, then run `check 1521`.  
To experiment with the same test files the checker uses: `play 1521`.
