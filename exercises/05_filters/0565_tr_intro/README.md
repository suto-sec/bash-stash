# 0565 · tr: translating characters

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** tr

`tr A B` replaces, character by character, the characters of `A` by those of `B`. It reads **standard input** (the text that arrives into your script), not files.

The checker sends some words into your script on standard input. Print them with every lowercase letter converted to uppercase.

Example: if the input is `hola mundo`, the output is `HOLA MUNDO`.

Hint: `tr 'a-z' 'A-Z'` (a range of letters on each side).
