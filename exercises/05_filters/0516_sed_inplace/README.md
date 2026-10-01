# 0516 · Editing a file in place

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** sed -i

Modify the file `app.conf` **in place** (no output):

- change the line `debug=false` into `debug=true`
- change every occurrence of `localhost` into `127.0.0.1`
- delete every line containing `deprecated`

Use `sed` (with its in-place option).
