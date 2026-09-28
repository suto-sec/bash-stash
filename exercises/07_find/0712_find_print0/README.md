# 0712 · Names with spaces

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -print0, xargs -0

Under `docs` there are `.txt` files, some with **spaces** in their names. Print the **total number
of lines** of all of them (just the number).

Use `find -print0 | xargs -0 cat | wc -l`. Try a naive `cat $(find ...)` in `play 0712` to see
why it breaks.

---
Write your solution in `answer.sh`, then run `check 0712`.  
To experiment with the same test files the checker uses: `play 0712`.
