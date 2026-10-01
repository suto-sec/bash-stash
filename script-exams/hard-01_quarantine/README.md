# hard-01 · Quarantine for world-writable files

**Tier:** hard · **Script:** `quarantine.sh`

Write a shell script called `quarantine.sh` that takes one optional argument:

```
quarantine.sh [directory]
```

The script moves to the directory `$HOME/quarantine` every **regular file** (not directories, not symbolic links) found under `directory` (including its subdirectories) that **is writable by "others"** (the `o+w` permission) and whose name **does not end in `.tmp`**. Every moved file must lose its write permission for others (`o-w`).

- If more than one argument is given, print an error message **and the correct usage** on standard error and exit with code **1**.
- If `directory` does not exist, print an error message that includes the name on standard error and exit with code **2**.
- If `directory` exists but is not a directory, print an error message that includes the name on standard error and exit with code **3**.
- If no argument is given, use the current directory.
- If `$HOME/quarantine` does not exist, create it and print on standard output exactly `Directory <full path> created`.
- Process the files in alphabetical order of their full path (as `sort` orders them). If a file with the same name already exists in the quarantine (from before, or moved earlier in this run) it must **not** be overwritten: store the new one as `<name>.1`, or `<name>.2`, ... using the first free number.
- A file may fail to move (for instance because its directory is read-only). Then print `could not move <path>` on standard error and go on with the next one; it does not count.
- At the end print on standard output exactly `Quarantined N files`, where `N` is the number of files moved successfully (always the plural, even if `N` is 0 or 1).
- If at least one file could not be moved, exit with code **4** after printing the summary; otherwise exit with code 0.

File names and directories may contain spaces.

Don't forget:
- Argument checking and error messages (2 points).
- Creating `$HOME/quarantine` and printing the message (1 point).
- Choosing the right files: permission, type, name and recursion (2 points).
- Never overwriting: the `.1`, `.2`, ... suffixes in alphabetical order (2 points).
- Files that cannot be moved: message, count and exit code 4 (2 points).
- The whole script working on the current directory (1 point).
