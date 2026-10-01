Add the checks, in this order:

1. Not exactly one argument: error message **and the correct usage** on standard error, exit code **1**.
2. The argument is not a positive integer (digits only, at least 1): error message that includes it, exit code **2**.

Nothing goes to standard output when there is an error.
