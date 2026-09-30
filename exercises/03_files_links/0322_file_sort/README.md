# 0322 · Sorting files by their real type

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** file -b, mkdir, mv, case / [[ == *text* ]]

The directory `mezcla` contains files whose extensions lie. Create `mezcla/texto` and `mezcla/otros`
and move every **regular file** of `mezcla` into:

- `mezcla/texto` if its type, as described by `file -b`, contains the word `text`
- `mezcla/otros` otherwise (including empty files)

Finally print `text: N` and `other: M` (two lines). Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0322`.  
To experiment with the same test files the checker uses: `play 0322`.
