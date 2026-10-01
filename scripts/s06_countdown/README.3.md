`countdown.sh` now takes an **optional second argument, the step**: how much the counter goes down each time. Without it the step is 1, so everything written so far keeps working.

```
countdown.sh 10 3   ->   10
                         7
                         4
                         1
                         Liftoff!
```

The counter still stops as soon as it is no longer above 0 (`10, 7, 4, 1`: the next one would be `-2`, so `Liftoff!` follows `1`).

Checks, in this order:

1. No argument, or more than two: the usage message on standard error, exit code **1**.
2. `N` or the step is not a positive integer: error message that includes the offending value, exit code **2** (nothing on standard output).
