# 1435 · Is this word in the list? (exact match)

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** case, for, break

The first argument is NEEDLE; the rest are a list of words (HAYSTACK). Using a loop and a `case`
that matches NEEDLE **exactly** (not a substring: quote the pattern so it can't glob), find the
**first** position (1-based) of NEEDLE in HAYSTACK. Print `SI: posicion P` if found (stop looking
with `break`), or `NO` if it never appears. With no HAYSTACK words at all, print `NO`.
