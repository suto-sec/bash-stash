# 1107 · Cutting strings with ${ }

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★★★☆☆ · **Commands:** ${v#}, ${v##}, ${v%}, ${v%%}, ${v/a/b}, ${v:o:l}

The file `fichero.txt` contains a path like `/home/alumno/docs/informe.final.pdf`.
**Without** external commands (no `basename`, `sed`, `cut`...), only parameter expansion, print:

1. the file name (`informe.final.pdf`) — `${P##*/}`
2. the directory (`/home/alumno/docs`) — `${P%/*}`
3. the name without the **last** extension (`informe.final`)
4. only the **last** extension (`pdf`)
5. the path with every `/` replaced by `:` — `${P//\//:}`
6. the first 5 characters of the path
