Before the `Jobs: N` line print `user: N` for every user that ran at least one job (the name between the first parentheses of the line), sorted by user name.

`read -r -a w` and `${w[5]}` is `(ana)`: strip the parentheses with `${w[5]#(}` and `${u%)}`.
