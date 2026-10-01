# 0331 · Copying by extension, keeping the tree shape

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** find, mkdir -p, dirname, cp

Under `origen` there is a tree of subdirectories containing files with mixed extensions. Copy every
regular file whose name ends in `.log` (any depth) into `destino`, **keeping the same relative path**
it had under `origen` (creating whatever subdirectories are needed under `destino`). Files with other
extensions are not copied, and `destino` may already contain unrelated files (leave them alone).

Finally print, sorted, the relative path (no leading `./`) of every file copied, one per line,
followed by `Copied: N`.
