Checks, in this order (errors go to standard error, nothing on standard output):

1. Not exactly two arguments: error message **and the correct usage** (e.g. `Usage: safecopy.sh source dest`), exit code **1**.
2. `SOURCE` is not a regular file (missing, or a directory): error message that includes its name, exit code **2**.
