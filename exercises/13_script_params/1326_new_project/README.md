# 1326 · mkproj.sh: a project skeleton

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★★☆ · **Commands:** ${2:-sh}, [[ =~ ]], case, mkdir -p, chmod, exit codes

Write `mkproj.sh`:

```
mkproj.sh name [lang]
```

It creates, in the current directory, a project called `name` for language `lang` (default `sh`):

```
name/
├── README          one line: "# name"
├── src/
│   └── main.EXT    (see below)
└── tests/          empty
```

| lang | file | content | permissions |
|------|------|---------|-------------|
| `sh` | `src/main.sh` | two lines: `#!/bin/bash` and `echo "Hello from name"` | 755 |
| `py` | `src/main.py` | one line: `print("Hello from name")` | 644 |
| `c`  | `src/main.c`  | one line: `int main(void) { return 0; }` | 644 |

(`name` in the contents is the project name.) On success print exactly
`Project <name> created (<lang>)`.

Errors, checked in this order (message on **stderr**, wording free, nothing created):

| error | exit |
|-------|------|
| not 1 or 2 arguments (show the usage) | 1 |
| `name` does not match: a letter followed by letters, digits, `_` or `-` (name it) | 2 |
| `lang` is not exactly `sh`, `py` or `c` (name it) | 3 |
| something called `name` already exists in the current directory (file, directory...) (name it) | 4 |
