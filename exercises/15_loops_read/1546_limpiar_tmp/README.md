# 1546 · limpiar_tmp.sh: deleting matched files while tallying bytes freed

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** find -print0, sort -z, while read -r -d '', rm, stat

Write `limpiar_tmp.sh DIR`. Recursively find every **regular file** under DIR (any depth) whose name
ends in `.tmp` or `.bak` (case-sensitive), safely (`find ... -print0 | sort -z | while IFS= read -r
-d '' f; do ... done`, names may contain spaces). For each match, in that order: get its size, delete
it (`rm`), and print `borrado: PATH (N bytes)`.

Finally print `TOTAL: borrados R archivos, L bytes liberados` (R = files deleted, L = bytes freed).
A file like `keep2.bakup` does **not** count (it does not end in exactly `.bak`).

Errors (stderr, wording free, checked in this order): not exactly 1 argument -> usage, exit **1**;
DIR does not exist -> exit **2** (name it); DIR exists but is not a directory -> exit **3** (name it).
