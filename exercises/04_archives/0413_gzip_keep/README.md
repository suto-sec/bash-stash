# 0413 · gzip -k and reporting uncompressed sizes

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** gzip -k, zcat, wc -c

The directory `entradas` contains several `.csv` files, and a decoy file `entradas/notas.tmp`
that must remain untouched.

1. Compress every `.csv` file in `entradas` with `gzip`, but **keep** the original files too
   (see `gzip -k`).
2. Then, for each resulting file `entradas/NAME.csv.gz` (in the order given by the `*.csv.gz`
   glob), print a line:

   ```
   entradas/NAME.csv.gz: N bytes
   ```

   where `N` is the **uncompressed** size, obtained with `zcat ... | wc -c` (do not use `gzip -l`).
