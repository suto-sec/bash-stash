# 0632 · todos.sh (collecting TODO comments)

**Topic:** grep & regular expressions · **Difficulty:** ★★★★☆ · **Commands:** grep -r -n -E, --include, sort -t: -k, sed

Write `todos.sh`:

```
todos.sh DIR [TAG]
```

`TAG` is one of `TODO`, `FIXME`, `XXX` (default `TODO`). It scans the regular files whose name ends in
`.sh` or `.c` under `DIR` (recursively). A line contains the tag when `TAG` appears (exact case)
**immediately followed by `:`** and preceded by the start of the line or by a character that is not
a letter, digit or `_` (so `#TODO:` and `// TODO:` count; `MYTODO:`, `TODO_x:`, `todo:` and `TODO x` do not).
Each such line contains the tag only once.

For every such line print

```
<path>:<line number>: <text>
```

where `path` is as found under `DIR` and `text` is what follows `TAG:` on the line, without the
leading spaces. Order: by path (as `sort` orders paths), then by line number. Finally print the summary
`<N> <TAG> in <M> files` (e.g. `5 TODO in 2 files`, also `0 TODO in 0 files`). Exit code 0.

Errors (message on **stderr**): no arguments or more than 2 → usage, exit **1**; `DIR` is not a
directory → exit **2** (mention it); invalid `TAG` → exit **3** (mention it). Checked in that order.
