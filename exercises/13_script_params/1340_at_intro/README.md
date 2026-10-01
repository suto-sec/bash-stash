# 1340 · "$@" keeps arguments intact

**Topic:** Script parameters & exit codes · **Difficulty:** ★☆☆☆☆ · **Commands:** "$@", for

`"$@"` stands for all the arguments, each one kept as a single word (even if it contains spaces). A `for` loop over `"$@"` visits them one by one.

Print every argument on its own line, with `- ` (a dash and a space) in front. Use a `for` loop over `"$@"`.

Example: run as `./script.sh uno "dos tres"` it prints:

```
- uno
- dos tres
```

With no arguments nothing is printed.

Hint: `for a in "$@"; do ...; done`
