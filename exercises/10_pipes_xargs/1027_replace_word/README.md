# 1027 · replace.sh (search and replace in many files)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** grep -lZ, xargs -0, sed -i, grep -o | wc -l

Write `replace.sh`:

```
replace.sh WORD REPLACEMENT DIR
```

It replaces **every occurrence** of `WORD` by `REPLACEMENT` in every **regular file** under `DIR`
(recursively) whose name ends in `.txt` and that contains `WORD` (case-sensitive; `WORD` may appear
inside longer words, it is a plain substring). Other files are not modified.

For each modified file, sorted by path (as `sort` orders them; the path as `find DIR` prints it), print

```
<path>: <N> replacements
```

where `N` is the number of occurrences of `WORD` in that file before replacing (`grep -o WORD file | wc -l`).
Finish with `Replaced <T> occurrences in <M> files` (also when nothing was found: `Replaced 0
occurrences in 0 files`).

Validation, in this order (message on **stderr**):

- not exactly 3 arguments: usage, exit **1**
- `WORD` or `REPLACEMENT` is not made only of letters, digits and `_` (at least one character):
  exit **2**, naming the bad argument
- `DIR` is not a directory: exit **3**

Names may contain spaces. Hint: `grep -lZ WORD ... | xargs -0 sed -i "s/WORD/REPLACEMENT/g"`.
