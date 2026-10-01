A path can exist and still be neither a regular file nor a directory (for example a named pipe: `pipe1` in the checker). For such a path print `PATH: other` on **standard output** and exit with code **3**.

`[[ -e path ]]` is true for anything that exists.
