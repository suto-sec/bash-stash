# 0539 · csvcol.sh (a column by its name)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** head, tr, grep -n, cut, tail, sort -u, wc

Write `csvcol.sh`:

```
csvcol.sh FILE COLUMN
```

`FILE` is a CSV file: the first line is a header with the column names, the rest are data rows;
the separator is `,` and there is no quoting (no field contains a comma; names and values may
contain spaces). The script prints the values of the column whose header name is **exactly**
`COLUMN`, one per line, in file order; an empty value is printed as `(empty)`. Then it prints the
summary line:

```
N values, D distinct, E empty
```

where N = number of data rows, D = number of **different non-empty** values, E = empty values.

Errors (message on **stderr**, nothing on stdout):

- not exactly 2 arguments: an error message **and the usage**, exit code **1**
- `FILE` is not a readable regular file: message including the name, exit code **2**
- no column is named `COLUMN` (exact, whole name: `nam` does not match `name`): message including
  `COLUMN`, exit code **3**
