A `passwd` file has one line per account, fields separated by `:`; the **7th** field is the login shell. Write `shells.sh FILE`. It prints one line `SHELL: N` for each shell (N = how many accounts use it), **the most used shell first**; shells with the same count in alphabetical order (as `sort` orders text).

Example line: `/bin/bash: 3`.
