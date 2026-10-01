# 0308 · Symbolic links

**Topic:** Files, copies & links · **Difficulty:** ★★☆☆☆ · **Commands:** ln -s, readlink

The directory `Datos` contains a file `borrador` and a directory `Stocks`.

1. Create a **symbolic link** `Datos/Stocks/enlacesimbolico` whose stored target is the **relative**
   path `../borrador`.
2. Create a symbolic link `acceso` in the current directory whose target is the **absolute** path
   of `Datos` (use `$PWD`).
3. Print the targets stored in both links with `readlink`.
4. Print the content of the file through the first link.
