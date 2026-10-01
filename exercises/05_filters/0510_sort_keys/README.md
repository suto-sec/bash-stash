# 0510 · Sorting by a field

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** sort -t -k

`notas.txt` contains lines `name:subject:grade`. Print:

1. the lines sorted by **grade** (field 3), highest first (numeric)
2. `---`
3. the lines sorted by **subject** (alphabetical), and for the same subject by **grade** descending

Use `-t:` and `-k` with a field range (`-k3,3n`), not just `-k3`.
