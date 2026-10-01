A path can exist and be neither a regular file nor a directory (for example a named pipe). Then print `PATH: other` on standard output and exit with code **3**.

`[[ -e path ]]` is true for anything that exists.
