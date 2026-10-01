Every argument must be a non-negative integer (only digits). If one is not, print an error message that includes the offending argument on standard error and exit with code **2**, without printing a total. Check **all** arguments before adding.

`[[ $n =~ ^[0-9]+$ ]]` tests that `$n` is made only of digits.
