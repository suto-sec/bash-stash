# 1018 · The longest text files

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** find -print0, xargs -0 wc -l, sort -k, head

Under `docs` (recursively) there are `.txt` files (some with spaces in their names) and other files
that must be ignored. There are always at least 3 `.txt` files. Print:

1. the **3** `.txt` files with the most lines, most lines first (ties: path in alphabetical order,
   as `sort` orders them), as

   ```
   <lines> <path>
   ```

   with exactly one space, and the path as `find docs` prints it;
2. a last line `Total: N lines` with the number of lines of all the `.txt` files together.

Hint: `find ... -print0 | xargs -0 wc -l` prints one line per file (plus a `total` line);
`sed 's/^ *//'` removes the padding.
