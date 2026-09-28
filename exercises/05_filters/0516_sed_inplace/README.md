# 0516 · Editing a file in place

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** sed -i

Modify the file `app.conf` **in place** (no output):

- change the line `debug=false` into `debug=true`
- change every occurrence of `localhost` into `127.0.0.1`
- delete every line containing `deprecated`

---
Write your solution in `answer.sh`, then run `check 0516`.  
To experiment with the same test files the checker uses: `play 0516`.
