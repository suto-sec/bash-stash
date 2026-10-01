# 0507 · cut by characters and output delimiter

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★☆☆☆ · **Commands:** cut -c, cut --output-delimiter

`ls_output.txt` contains lines from `ls -l`. Print:

1. the first 10 characters of every line (the type and permissions)
2. a line `---`
3. the fields 1 and 3 of the file `notas.csv` (separated by `;`), but printed separated by ` | `
   (see `--output-delimiter`)
