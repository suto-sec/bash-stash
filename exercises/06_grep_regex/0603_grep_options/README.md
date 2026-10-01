# 0603 · -i -v -c -n

**Topic:** grep & regular expressions · **Difficulty:** ★☆☆☆☆ · **Commands:** grep -i -v -c -n

For the file `log.txt`, print separated by `---`:

1. lines containing `error` in any case (`Error`, `ERROR`...) with their **line numbers**
2. the **number** of lines that do **not** contain `error` (any case)
3. lines that contain `warn` (exact case) but **not** `disk`
