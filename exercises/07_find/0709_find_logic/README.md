# 0709 · Combining conditions: ! -o ( )

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find !, -o, \( \)

Under `docs`, print sorted all files **and** directories whose name starts
with `a` **or** `b` and does **not** contain the character `~`.

Careful: `-o` has lower precedence than the implicit AND; you need `\( ... -o ... \)`.

---
Write your solution in `answer.sh`, then run `check 0709`.  
To experiment with the same test files the checker uses: `play 0709`.
