Add the error handling, checked in this order:

1. Not exactly one argument: error message **and the correct usage** on standard error, exit code **1**.
2. The argument does not exist or is not a regular file (a directory, for instance): error message that includes its name, exit code **2**.
3. The file exists but is not readable: error message that includes its name, exit code **3**.

Errors go to standard error and nothing is printed on standard output.
