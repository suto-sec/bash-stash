# 0709 · Combining conditions: ! -o ( )

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find !, -o, \( \)

Under `docs`, print sorted all files **and** directories whose name starts
with `a` **or** `b` and does **not** contain the character `~`.

Careful: `-o` has lower precedence than the implicit AND; you need `\( ... -o ... \)`.
