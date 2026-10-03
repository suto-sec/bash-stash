# Writing the Reference manual

Entries live in `web/public/manual-<category>.js` and register with `MANUAL.add('<category>', [ {...}, ... ])`. The loader, the entry format
and the renderer are in `web/public/manual.js` (read the header comment). A reader should never have to open `man` after reading an entry:
**describe every option**, give an example for **every use case**, and explain the pitfalls.

## Entry fields

| field | |
|-------|--|
| `name`, `key` | shown name; the key (default: lower-case name) is the URL / link target (`#/reference/cmd/<key>`) |
| `kind` | `builtin`, `command`, `syntax`, `file` or `concept` |
| `aliases` | every token an exercise's `Commands:` line (or a *see also*) may use for this entry: `find -name`, `2>&1`, `/etc/passwd`... A token can belong to **one** entry only (the runner reports collisions) |
| `summary` | one line; also what the Info panel shows |
| `synopsis[]`, `desc[]` | usage lines; paragraphs (a block of `- ` lines is a list; `` `code` `` and `**bold**` work) |
| `options` | `[{flag, desc}]` or groups `[{title, items:[...]}]`; `flag` may hold several spellings separated by ` \|\| ` |
| `sections` | extra blocks `{title, body[]?, table?, code?, after?}` (tables: first row is the header) |
| `examples[]` | `{title, cmd, note?, fails?, norun?, out?}` — see below |
| `exit[]`, `notes[]`, `see[]` | exit status lines, pitfalls, links to other entry keys (aliases work too) |

## Examples are executed

`./lab node tools/build_manual.js [--only key,key] [--check]` (run it **inside a lab instance**, e.g. `LAB_INSTANCE=man ./lab node ...`) runs every
example with `bash -c` in a fresh empty directory (`$HOME` is that directory, locale `en_US.UTF-8`, `TZ=UTC`) and stores the output in
`web/public/manual-outputs.json` (key `entrykey#index`). Rules:

- Examples must be **self-contained**: create their own files (`printf`, `echo`, `touch`, `mkdir`, here-documents). Do not rely on a previous example.
- Output must be **deterministic**: pin dates (`touch -d`, `--time-style=long-iso`), do not print PIDs, inodes, host names or user names (the lab user
  is shown as `carlos`). `--check` runs everything twice and flags differences and anything that shows today's date.
- The exit status must be 0, unless the example says `fails: true` (it then demonstrates an error).
- Background jobs are killed and reaped at the end of each example; use a **copy of sleep with a unique name** (`cp "$(command -v sleep)" napper`)
  before `pkill`/`killall`, so nothing else can match.
- Anything that cannot be executed safely or repeatably — needs root and changes the system (`useradd`, `systemctl`, `mount`...), a terminal, a
  network, time-dependent output — is `norun: true` with a hand-written `out`. Take the text from a real session whenever you can.
- A shell prelude (`trap ... EXIT`) is added to the first line of each example, so line numbers in error messages stay those of the example.

## Tokens that are syntax

`web/public/manual-rules.js` maps tokens that are not words (`${v%.*}`, `$(( ))`, `2>&1`, `{1..5}`, `[[:digit:]]`...) to entries with regular
expressions. `node tools/manual_coverage.js` lists the tokens of all exercises and scripts that resolve to nothing (aim: none that matter).
