# 1329 · mkdirs.sh: numbered directories

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** ${3:-dir}, printf %02d, test -e -d, [[ =~ ]], exit codes

Write `mkdirs.sh`:

```
mkdirs.sh base count [prefix]
```

It makes sure that directory `base` contains the entries `<prefix>01`, `<prefix>02`, ...,
`<prefix>NN` (two digits, NN = `count`); `prefix` defaults to `dir`. For each number, in order:

- if something with that name already exists (directory, file...), print `exists: <base>/<name>`
  and leave it alone
- otherwise create the directory and print `created: <base>/<name>`

(`<base>` exactly as given). Finally print `Created C, existing E`.

Errors, checked in this order (message on **stderr**, wording free, nothing created):

| error | exit |
|-------|------|
| not 2 or 3 arguments (show the usage) | 1 |
| `base` does not exist (name it) | 2 |
| `base` is not a directory (name it) | 3 |
| `count` is not an integer from 1 to 99 written without leading zeros (name it) | 4 |
| `prefix` is empty or has characters other than letters and `_` (name it) | 5 |
