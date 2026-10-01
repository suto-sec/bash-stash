# 1128 · export: passing a variable to a child shell

**Topic:** Variables, arithmetic & environment · **Difficulty:** ★☆☆☆☆ · **Commands:** export

A variable belongs to your shell only. `export` also hands it over to the programs your shell starts (child processes), such as another `bash`.

1. Create the variable `MSG` with the value `hola` and export it: `export MSG=hola`
2. Run a child shell that prints it: `bash -c 'echo "$MSG"'`

Expected output:

```
hola
```

Without `export` the child shell would print an empty line.
