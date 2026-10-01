Write `lastword.sh FILE`. It prints the **last word** of every line of `FILE` (words are separated by blanks; trailing blanks do not count). A blank line prints a blank line.

`while read -r -a words; do echo "${words[-1]}"; done < file` splits each line into an array.
