# 1551 · Quick refresher: read -p

**Topic:** Loops: for, while, until, read · **Difficulty:** ★☆☆☆☆ · **Commands:** read -p

`read -p "text" VAR` shows `text` as a prompt, then reads one line into `VAR`. The prompt is only displayed when the input comes from a keyboard, so you will see it when you run the script yourself, but not when the checker feeds the name into the script.

Ask for a name with `read -p "Name: " NAME` and print `Hello, ` followed by the name and an exclamation mark.

Example: if the name read is `Ana`, the output is:

```
Hello, Ana!
```

---
Write your solution in `answer.sh`, then run `check 1551`.  
To experiment with the same test files the checker uses: `play 1551`.
