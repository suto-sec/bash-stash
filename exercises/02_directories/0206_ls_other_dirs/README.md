# 0206 · Listing without moving

**Topic:** Directories & navigation · **Difficulty:** ★☆☆☆☆ · **Commands:** ls, relative paths

The current directory contains `Datos/{Inversiones,Nominas,Stocks}` and `Textos/{Cartas,Informes}`,
each with some files. **Without using `cd`**, print (in this order):

1. the content of `Textos/Cartas`
2. the content of the parent directory of `Stocks`, reached as `Datos/Stocks/..`
3. the content of `/usr/share/dict`

(Plain `ls DIR` for each; each listing is one entry per line.)
