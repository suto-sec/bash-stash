# 0409 · bzip2, bunzip2 and -k

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** bzip2, bunzip2 -k, bzcat

The directory `datos` contains:

- a subdirectory `datos/normal/` with several `.dat` files
- a file `datos/plantilla.dat`
- an already-compressed `datos/notas.dat.bz2`
- a file `datos/leeme.txt` that must **not** be touched

Do, in this exact order:

1. Print the content of `datos/notas.dat.bz2` **without** decompressing it to disk (`bzcat`, or
   `bzip2 -dc`).
2. Compress every `.dat` file inside `datos/normal` with `bzip2` (each file disappears, replaced
   by its `.bz2`).
3. Compress `datos/plantilla.dat` with `bzip2`, but this time **keep** the uncompressed original
   too (see `bzip2 -k`).
