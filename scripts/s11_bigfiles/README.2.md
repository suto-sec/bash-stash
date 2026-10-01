Checks, in this order (errors on standard error, nothing on standard output):

1. Not exactly one argument: error message **and the correct usage** (e.g. `Usage: bigfiles.sh dir`), exit code **1**.
2. `DIR` does not exist: error message with its name, exit code **2**.
3. `DIR` exists but is not a directory: error message with its name, exit code **3**.
