# 0603 · -i -v -c -n

**Topic:** grep & regular expressions · **Difficulty:** ★☆☆☆☆ · **Commands:** grep -i -v -c -n

For the file `log.txt`, print separated by `---`:

1. lines containing `error` in any case (`Error`, `ERROR`...) with their **line numbers**
2. the **number** of lines that do **not** contain `error` (any case)
3. lines that contain `warn` (exact case) but **not** `disk`

---
Write your solution in `answer.sh`, then run `check 0603`.  
To experiment with the same test files the checker uses: `play 0603`.
