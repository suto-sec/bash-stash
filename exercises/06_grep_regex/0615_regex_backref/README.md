# 0615 · Back-references

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep, \(\) \1

Print the words of `/usr/share/dict/words` that:

1. contain the **same letter three times in a row** (e.g. `...eee...`)
2. `---`
3. are 5-letter palindromes in lowercase (like `level`, `radar`)

Use basic regex groups `\(.\)` and back-references `\1`.

---
Write your solution in `answer.sh`, then run `check 0615`.  
To experiment with the same test files the checker uses: `play 0615`.
