# 0627 · Vowel puzzles in the dictionary

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -E, [^...], {n,}, \1

Using `/usr/share/dict/words`, consider only the words made **only of lowercase letters a-z**.
Print, separated by `---`:

1. the words that contain the vowels `a`, `e`, `i`, `o`, `u` **in this order** (other letters, also
   vowels, may appear anywhere in between), e.g. `facetious`
2. the words of **6 or more** letters that contain **none** of `a e i o u` (`y` is fine)
3. the **number** of words of at least 5 letters that **start and end with the same two letters**
   in the same order (e.g. `alphabetical`: `al...al`)

Each part is a single `grep -E` (back-references work in `grep -E` too).

---
Write your solution in `answer.sh`, then run `check 0627`.  
To experiment with the same test files the checker uses: `play 0627`.
