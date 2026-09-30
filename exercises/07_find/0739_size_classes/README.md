# 0739 · tallas.sh: files by size class

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -empty, -size +Nc -size -Nc, for "$@", exit codes

Write `tallas.sh`:

```
tallas.sh DIR...
```

For each `DIR`, in argument order, count its **regular files** (recursively) by size class and print

```
DIR: <E> empty, <S> small, <M> medium, <L> large
```

(DIR as given) where

| class  | size in bytes            |
|--------|--------------------------|
| empty  | 0                        |
| small  | 1 to 1024                |
| medium | 1025 to 1048576 (1 MiB)  |
| large  | more than 1048576        |

If a `DIR` is not a directory, print an error message including it on **stderr**, skip it and go on.
Finally print `Total: N files` (sum of the counts of all printed lines).

Exit code: no arguments → usage on stderr, exit **1**; if some `DIR` was not a directory, exit **2**
(after processing all of them); otherwise 0.

Careful with `-size` units: `-size -1k` does **not** mean "less than 1024 bytes". Use `c`.
Names may contain spaces.

---
Write your solution in `answer.sh`, then run `check 0739`.  
To experiment with the same test files the checker uses: `play 0739`.
