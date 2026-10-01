# 1629 · tamano_rec.sh: a recursive du -s, in miniature

**Topic:** Functions · **Difficulty:** ★★★★☆ · **Commands:** recursion, find -maxdepth 1 -print0, read (multi-value), local

Write `tamano_rec.sh DIR`, a recursive stand-in for `du -s`. Write a **recursive** function
`tamano DIR` that **echoes** three numbers on one line: `BYTES FILES DIRS` — the total size in
bytes of every regular file under DIR (any depth, hidden files included), the count of such files,
and the count of subdirectories under DIR at any depth (DIR itself not counted). Symbolic links are
ignored (neither followed nor counted).

Implement it by listing DIR's **direct** entries safely:
`find DIR -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' e; do ... done`. For a direct
entry that is itself a directory, get its own totals with `read -r b f d <<< "$(tamano "$e")"` and
add them in (plus 1 for that subdirectory itself).

Print `TOTAL: DIR = B bytes (F files, D dirs)`.

Errors (stderr, wording free): not exactly 1 argument -> usage, exit **1**; DIR is not a directory
-> exit **2** (name it).
