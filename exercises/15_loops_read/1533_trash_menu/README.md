# 1533 · papelera.sh: a select menu that moves files

**Topic:** Loops: for, while, until, read · **Difficulty:** ★★★★☆ · **Commands:** select, read, mv, case, counters

Write `papelera.sh DIR`, an interactive trash can driven by a menu:
`select op in list delete restore quit` (menu and prompt go to stderr; choices come from stdin).

- `list`: print `- NAME` for every regular file directly in DIR (glob `DIR/*` order, hidden files not
  included) or `(no files)` if there are none; then print `trash: N` (N = entries in `DIR/.trash`,
  0 if it does not exist)
- `delete`: read the **next line** of stdin as a file NAME. If `DIR/NAME` is a regular file, move it
  into `DIR/.trash/` (create it if needed; overwrite a file with the same name there) and print
  `deleted NAME`; otherwise print `no such file: NAME`
- `restore`: read the next line as NAME. If `DIR/.trash/NAME` does not exist print
  `not in trash: NAME`; else if `DIR/NAME` already exists print `cannot restore NAME: exists`;
  else move it back to DIR and print `restored NAME`
- `quit`: leave the menu; any invalid choice: print `invalid option`

When the menu ends (by `quit` or end of input) print `deleted D, restored R`.
Names may contain spaces (read the whole line). Errors (stderr): not exactly 1 argument → **1**;
DIR not a directory → **2** (name it).

---
Write your solution in `answer.sh`, then run `check 1533`.  
To experiment with the same test files the checker uses: `play 1533`.
