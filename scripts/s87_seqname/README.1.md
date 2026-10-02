Write `seqname.sh DIR PREFIX`. The **regular files** directly in `DIR` (not hidden ones, not directories) are taken **in the order `ls` lists them** and renamed to `PREFIX-001.ext`, `PREFIX-002.ext`... : a three-digit counter starting at 1 and the **same extension** as before (the text after the last dot, with the dot; a name without a dot gets none). For each file print `old -> new`, in that order.

Example (files `b.jpg a.png`): `a.png -> img-001.png` then `b.jpg -> img-002.jpg`. In this step assume none of the new names exists yet.
