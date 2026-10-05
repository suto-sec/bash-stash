# medium-02 · Staging configuration files

**Tier:** medium · **Script:** `stage_configs.sh`

Write a shell script called `stage_configs.sh` that takes one optional argument:

```
stage_configs.sh [directory]
```

The script looks under `directory` (including all its subdirectories) for **regular files** (not directories, not symbolic links) that meet **all** of these conditions, and copies them into the directory `$HOME/staging`:

- the name ends in `.conf` or `.cfg` (lower case);
- the size is **larger than 1024 bytes** (a file of exactly 1024 bytes does not count);
- the file is **not inside a directory called `old`**, at any depth.

Only the file name is kept (`directory/net/hosts.conf` becomes `$HOME/staging/hosts.conf`). A file that already exists in the destination is overwritten; other files of the destination are left alone. File names may contain spaces.

Rules:

1. More than one argument: print an error message **and the correct usage**, exit code **1**.
2. `directory` does not exist: error message that includes its name, exit code **2**.
3. `directory` exists but is not a directory: error message that includes its name, exit code **3**.
4. No argument: use the current directory.
5. If `$HOME/staging` does not exist, create it and print `Created /home/.../staging` (the full path of the directory).
6. At the end print how many files were copied, exactly in this form (also when it is zero): `Staged N files`.

Errors go to standard error. The messages of the rules 5 and 6 go to standard output.

Don't forget:
- Argument checking and error messages, in the right order (3 points).
- Choosing exactly the files described: suffix, size, regular files only, skipping `old` (3 points).
- Creating `$HOME/staging` with its message and overwriting existing copies (2 points).
- Counting the copied files and printing the final message, also with the current directory and with zero files (2 points).
