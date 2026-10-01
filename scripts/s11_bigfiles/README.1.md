Write `bigfiles.sh DIR`. It prints every **regular file directly inside** `DIR` (no subdirectories) that is **larger than 100 bytes**, as `name: SIZE` (the name without the directory, the size in bytes). The order does not matter.

`stat -c %s file` prints the size of a file in bytes. File names may contain spaces.
