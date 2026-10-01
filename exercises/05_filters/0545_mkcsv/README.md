# 0545 · mkcsv.sh (columns from several files)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** paste -d, paste -s, basename, wc -l

Write `mkcsv.sh`:

```
mkcsv.sh OUTPUT FILE1 FILE2 [FILE...]
```

Every input `FILE` contains one value per line. The script creates the CSV file `OUTPUT` with one
**column per input file**, in argument order:

- first line (header): the name of every input file **without its directory** and without a final
  `.txt` extension if it has one (`cols/day 1.txt` → `day 1`; `cols/temps` → `temps`), separated by `,`
- then the rows: line `i` of every file, separated by `,`. If some files are shorter, their
  missing values are empty (this is exactly what `paste -d,` does).

Then it prints `<OUTPUT>: <C> columns, <R> rows` (R = data rows, without the header).

Errors (message on **stderr**, nothing created), checked in this order:

- fewer than 3 arguments: error and usage, exit **1**
- an input is not a readable regular file: message with its name, exit **2**
- `OUTPUT` already exists: message with its name, exit **3**
