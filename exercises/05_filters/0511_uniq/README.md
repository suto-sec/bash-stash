# 0511 · Counting repetitions

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** sort | uniq, uniq -c, uniq -d

`accesos.txt` contains one user name per line (unsorted). Print, separated by `---`:

1. every user **once**, sorted
2. how many times each user appears, as `uniq -c` prints it (sorted by name)
3. only the users that appear **more than once** (sorted)

Remember: `uniq` only merges **adjacent** repeated lines, so sort first.
