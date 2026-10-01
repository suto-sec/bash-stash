# 1325 · notes.sh: a command with subcommands

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** shift, "$*", case, sed -i, exit codes

Write `notes.sh`, a tiny note keeper that stores one note per line in `$HOME/notes.txt`:

```
notes.sh add <text>...     append a note
notes.sh list              show the notes
notes.sh del <n>           delete note number n
notes.sh count             how many notes there are
```

- `add`: the note is all the remaining arguments joined by single spaces (`"$*"` after `shift`).
  Append it to the file (create it if needed) and print `Added note N`, N = its line number.
- `list`: print every note as `N: text`; if there are no notes (file missing or empty) print `No notes`.
- `del n`: delete line `n` and print `Deleted note n: text` (the deleted text).
- `count`: print `N notes` (`0 notes` if the file does not exist).

Errors (message on **stderr**, wording free, the file is not modified):

| error | exit |
|-------|------|
| no arguments (show the usage) | 1 |
| unknown subcommand (name it) | 2 |
| wrong number of arguments for the subcommand (`add` needs at least 1, `del` exactly 1, `list`/`count` none) | 3 |
| `del` with something that is not the number of an existing note (name it) | 4 |
