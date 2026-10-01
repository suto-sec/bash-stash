# 0921 · mkconf.sh (generating a config file)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** cat > file << EOF, \$, mkdir -p, [[ =~ ]], shift

Write `mkconf.sh`:

```
mkconf.sh [-f] NAME PORT
```

It writes the file `$HOME/.config/apps/NAME.conf` (create the directory with its parents if needed,
silently) with a **here document**, with exactly this content:

```
# NAME configuration (generated)
[main]
name = NAME
port = PORT
user = <value of $USER>
log = <value of $HOME>/logs/NAME.log
[paths]
data = ${DATA_DIR}/NAME
```

(`NAME` and `PORT` replaced by the arguments; `${DATA_DIR}` is written **literally**, not expanded.)

- If the file already exists and `-f` was **not** given: error, exit **4**, the file is left untouched.
- Otherwise print `Created <path>` (it did not exist) or `Overwritten <path>` (it existed, `-f`),
  where `<path>` is the full path, and then the summary line
  `<k> configurations in <directory>`, `k` = number of files `*.conf` in that directory.

Errors (message on **stderr**), checked in this order:

| situation | exit |
|-----------|------|
| wrong arguments: `-f` is only allowed as the **first** argument, then exactly `NAME PORT` (show usage) | 1 |
| `NAME` is not a lowercase letter followed by lowercase letters, digits, `_` or `-` | 2 |
| `PORT` is not an integer 1..65535 written without leading zeros | 3 |
| file exists and no `-f` (mention the path) | 4 |
