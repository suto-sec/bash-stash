# 0638 · Extracting and version-sorting X.Y.Z numbers

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -Eo, \b, sort -t -k (numeric, multiple keys), sort -u

`versiones.txt` has lines of free text, some of which contain a version number in `X.Y.Z` form
(each of `X`, `Y`, `Z` is `0` or a number **without a leading zero**). Extract every such version
with a **single** `grep -Eo` call and print them **sorted numerically** (major, then minor, then
patch — not alphabetically: `2.0.0` must come before `10.0.0`), **without duplicates**.

Decoys that must **not** be extracted: a component with a leading zero (`01.2.3`), fewer than three
components (`1.2`), a non-digit component (`1.a.3`), and a version glued to a letter with no
separation (`v10.0.0` — there is no boundary between `v` and `1`, so it must not match; use `\b` to
require one).
