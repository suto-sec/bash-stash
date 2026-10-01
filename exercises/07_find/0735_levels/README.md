# 0735 · niveles.sh: entries per depth level

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -mindepth -maxdepth, loops, arithmetic

Write `niveles.sh`:

```
niveles.sh DIR [MAX]
```

`DIR` is level 0, its direct contents are level 1, and so on. Considering only **directories and
regular files** (symbolic links and anything else are ignored everywhere), it prints one line per
level from 1 up to the **deepest** level that has some entry (or up to `MAX` if it is given and
smaller):

```
level <L>: <D> dirs, <F> files
```

(D and F count the entries at **exactly** that depth; hidden entries count too). Then:

```
Deepest level: <X>
Total: <D> dirs, <F> files
```

where X is the deepest level of any directory or regular file under `DIR` (**ignoring** `MAX`; 0 if
`DIR` is empty) and the total is the sum of the printed levels.

Checks, **in this order** (stderr, wording free):

- no arguments or more than 2: usage, exit **1**
- `DIR` is not a directory: exit **2**
- `MAX` is not a positive integer (≥ 1): exit **3**

Names may contain spaces.
