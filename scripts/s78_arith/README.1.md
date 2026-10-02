Write `arith.sh A OP B`. `A` and `B` are integers (possibly negative) and `OP` is one of `+`, `-`, `x` (times), `/` (integer division, as `$(( ))` does) or `%` (remainder). Print only the result. Use `case` on `OP`.

Example: `arith.sh 7 x 6` prints `42`; `arith.sh 17 % 5` prints `2`. (The multiplication sign is the letter `x` because `*` is expanded by the shell.) You may assume the input is valid and `B` is not 0 for `/` and `%`.
