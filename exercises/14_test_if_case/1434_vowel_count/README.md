# 1434 · Counting vowels character by character

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** case, while, ${#s}, ${s:i:1}

For every argument (a word, letters only assumed), count how many of its characters are a vowel
(`a e i o u`, any case, no accents) by looping over its characters one at a time (`${w:i:1}`) and
matching each one with a `case` pattern. Print `WORD: N vocales`. Finally print `total: T` (T = sum
of vowels over every argument). With no arguments, print only `total: 0`.

---
Write your solution in `answer.sh`, then run `check 1434`.  
To experiment with the same test files the checker uses: `play 1434`.
