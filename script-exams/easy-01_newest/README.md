# easy-01 · The newest file

**Tier:** easy · **Script:** `newest.sh`

Write a shell script called `newest.sh` that takes one optional argument:

```
newest.sh [directory]
```

The script prints the **most recently modified regular file** that is directly inside `directory` (do not enter subdirectories; hidden files count; directories are not files), in this exact format:

```
<name> (<N> bytes)
```

where `<name>` is the file name without its directory and `<N>` its size in bytes.

- If more than one argument is given, print an error message **and the correct usage** on standard error and exit with code **1**.
- If `directory` does not exist, print an error message that includes the name on standard error and exit with code **2**.
- If `directory` exists but is not a directory, print an error message that includes the name on standard error and exit with code **3**.
- If no argument is given, use the current directory.
- If the directory has no regular files, print an error message on standard error and exit with code **4**.
- File names may contain spaces.

Don't forget:
- Argument checking and error messages (3 points).
- Finding the newest file and printing it in the exact format (4 points).
- Special cases: spaces in names, hidden files, a directory that is newer than every file, a directory without files (3 points).
