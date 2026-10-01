# 0911 · Process substitution

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** <( ), diff, comm

`lista1.txt` and `lista2.txt` contain names in random order. **Without creating temporary files**
(use `<(...)`), print:

1. the `diff` of both lists **once sorted**
2. `---`
3. the names that are in **both** lists (sorted), using `comm -12` on the sorted lists

The script must exit with code 0.
