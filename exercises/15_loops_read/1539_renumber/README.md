# 1539 · renumera.sh: renaming to the lowest free number

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** for glob, until, printf %03d, mv, [[ == ]]

Write `renumera.sh DIR EXT PREFIX`. It renames the regular files directly in DIR whose name ends in
`.EXT` (case-sensitive; hidden files excluded) to `PREFIX-NNN.EXT`, with NNN a 3-digit number:

- files whose name is **already** of the form `PREFIX-NNN.EXT` (exactly 3 digits) are left alone
- the others are processed in the order of the glob `DIR/*.EXT`; each one gets the **lowest** number
  starting at `001` such that `DIR/PREFIX-NNN.EXT` does not exist at that moment (an `until` loop is
  natural here)
- print `OLD -> NEW` (base names) for every rename, and finally `renamed N files`

Errors (stderr, checked in this order): not exactly 3 arguments → **1** (usage); DIR not a directory
→ **2** (name it); EXT not matching `^[a-z0-9]+$` → **3** (name it); PREFIX not matching
`^[A-Za-z0-9_]+$` → **4** (name it).
