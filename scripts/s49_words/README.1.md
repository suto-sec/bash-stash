Write `words.sh FILE`. For every line print `line N: W words` (`N` is the line number, `W` the number of words; words are separated by blanks, and a blank line has 0 words). Always the plural, `1 words` too.

`read -r -a w` puts the words of a line into an array: `${#w[@]}` is how many.
