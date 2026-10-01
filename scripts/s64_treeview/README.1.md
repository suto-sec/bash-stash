Write `treeview.sh DIR`. It prints every entry below `DIR` (files and directories, any depth), **sorted by path** (as `sort` orders the paths found by `find`), each one on its own line: the **name only**, preceded by **two spaces for each level** below `DIR` (entries directly inside `DIR` have no indentation).

```
assets
docs
  guide.md
```

`rel=${p#"$1"/}` is the path relative to `DIR`; `tr -cd / <<< "$rel" | wc -c` counts its slashes (the depth); `${rel##*/}` is the name.
