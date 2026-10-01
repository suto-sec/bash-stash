# 0562 · cut: extracting a field

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★☆☆☆☆ · **Commands:** cut -d -f

`cut` extracts columns from every line. `-d` sets the character that separates the fields and `-f N` chooses field number N (the first one is 1).

The file `datos.txt` has lines like `name:age:city`: three fields separated by `:`. Print only the **second** field (the age) of every line.

Example: if `datos.txt` contains

```
ana:31:madrid
luis:25:leon
```

the output is

```
31
25
```

Hint: `cut -d: -f2 file`
