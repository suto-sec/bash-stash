# 1305 · shift

**Topic:** Script parameters & exit codes · **Difficulty:** ★★☆☆☆ · **Commands:** shift

The first argument is a **title**; the rest are items. Print:

```
== TITLE ==
- item1
- item2
...
(N items)
```

Use `shift` to drop the title and then iterate over `"$@"`. With no arguments, print nothing and exit 0.
