# 0723 · The longest source files

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -exec wc -l {} \;, sort -k, head

Under `src`, print the **3** regular files ending in `.c` or `.h` with the **most lines**, as
`<lines> <path>` (exactly one space between them), from most to fewest lines; ties by path
(alphabetical). If there are fewer than 3 such files, print them all.

Careful: `wc -l file1 file2 ...` adds a `total` line at the end, which `-exec ... {} +` would give you.
Names may contain spaces.
