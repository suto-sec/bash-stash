# 0523 · Combining filters

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★☆☆ · **Commands:** cut, sort, head, tr

`ventas.csv` has a header line and then lines `fecha,producto,unidades,precio`.
Print the **3 products with most units** in one sale (lines, not aggregated), as `producto unidades`
separated by a single space, highest first (ties: product name alphabetically).
The header must be ignored.
