# 0344 · stat: basic metadata

**Topic:** Files, copies & links · **Difficulty:** ★☆☆☆☆ · **Commands:** stat -c

`stat` shows the information of a file. With `-c FORMAT` you choose what to print: `%s` is the size in bytes.

The current directory contains a file `f`. Print its size in bytes, and nothing else, with `stat -c %s`.

Expected output (the size changes on every run):

```
1234
```

Hint: `stat -c %s file`
