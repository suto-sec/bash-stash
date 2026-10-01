Write `kind.sh PATH`. It prints the path, a colon, a space and what the path is:

```
notes.txt: file
docs: directory
nothing: not found
```

`file` is for a regular file (`[[ -f path ]]`), `directory` for a directory (`[[ -d path ]]`); anything that does not exist prints `not found`. Paths may contain spaces. Use `play s02` to get the files the checker uses.
