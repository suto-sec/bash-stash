Write `mergecsv.sh A B`. Both files are CSVs whose **first line is the header**. Print the header of `A` once, then the data rows of `A`, then the data rows of `B` (their headers are skipped). Assume both files have a header line.

`head -n 1 "$1"` and `tail -n +2 "$1"`.
