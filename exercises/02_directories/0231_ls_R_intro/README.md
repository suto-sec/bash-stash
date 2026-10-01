# 0231 · ls -R: recursive listing

**Topic:** Directories & navigation · **Difficulty:** ★☆☆☆☆ · **Commands:** ls -R

The directory `arbol` contains some files and a subdirectory `sub`, which has a file of its own.

Print the recursive listing of `arbol` with `ls -R`: it lists the directory, and then every subdirectory under a header line with its path.

Expected output (the file names change on every run):

```
arbol:
sub
tomate.txt

arbol/sub:
mesa.txt
```

Hint: `-R` means recursive.
