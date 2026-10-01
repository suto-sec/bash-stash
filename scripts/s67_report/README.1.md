Write `report.sh DIR`. It looks at every **regular file below `DIR`** (any depth) and prints:

```
Files: 8
Total bytes: 2035
c: 2
md: 1
(none): 1
txt: 3
...
```

`Files` and `Total bytes` first, then one line `EXT: N` for each extension (what follows the **last** dot of the name; a name without a dot has the extension `(none)`), sorted by extension name. Hidden names count like any other.

`find "$1" -type f -printf '%s %f\n'` gives each size and name; `read -r size name` keeps the spaces of the name.
