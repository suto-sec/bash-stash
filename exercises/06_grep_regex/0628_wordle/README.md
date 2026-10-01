# 0628 · wordle.sh (a Wordle helper)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -x -E, grep -v, [...], ${var//_/.}, sort -u

Write `wordle.sh`:

```
wordle.sh DICT PATTERN [ABSENT]
```

- `DICT`: a file with one word per line.
- `PATTERN`: exactly 5 characters, each a lowercase letter `a-z` or `_` (unknown letter).
- `ABSENT` (optional): one or more lowercase letters that must **not** appear anywhere in the word.

The **candidates** are the lines of `DICT` that are exactly 5 lowercase letters `a-z` (nothing else
on the line), have the known letters of `PATTERN` in their positions, and contain none of the
`ABSENT` letters. Print the candidates **sorted and without duplicates**, one per line, and then
the summary line `<N> candidates` (always with that word, also `0 candidates`, `1 candidates`).
Exit code 0.

Errors (message on **stderr**, nothing on stdout):

| situation | exit |
|-----------|------|
| fewer than 2 or more than 3 arguments (show the usage) | 1 |
| `DICT` is not a readable regular file (mention it) | 2 |
| `PATTERN` is not valid (mention it) | 3 |
| `ABSENT` is given but is not 1+ lowercase letters (also if it is empty) | 4 |

Checks are done in that order.
