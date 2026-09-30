# 1632 · Quick refresher: local

**Topic:** Functions · **Difficulty:** ★☆☆☆☆ · **Commands:** local

Set `X=fuera` and print it. Define a function `f` that sets a **local** `X=dentro` and prints it,
then call `f`. Finally print `X` once more: it must still be `fuera`, since `f`'s `X` was local and
never touched the outer one.

---
Write your solution in `answer.sh`, then run `check 1632`.  
To experiment with the same test files the checker uses: `play 1632`.
