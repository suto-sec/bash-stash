# 1540 · Nested loops: counting duplicates without arrays

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★☆☆ · **Commands:** nested for, arrays, [ ]

`palabras.txt` has one word per line (a word may repeat). **Without associative arrays**, using
only nested loops over a plain array, for every **distinct** word, in the order of its first
appearance, print `WORD: N veces` if it appears **more than once** in the file (N = total number of
times it appears). Words that appear only once print nothing.

Finally print `distintas repetidas: D` (D = number of distinct words that appear more than once).

Suggested approach: load every line into an array `w`. Keep a second array `seen` of the words
already reported on. For each word of `w` not yet in `seen` (checked with an inner loop), count its
occurrences with another inner loop over `w`.

---
Write your solution in `answer.sh`, then run `check 1540`.  
To experiment with the same test files the checker uses: `play 1540`.
