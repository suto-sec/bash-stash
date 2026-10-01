Write `initials.sh NAME`. `NAME` is one argument with several words (`"ana maria ruiz"`). Print the **initials** of its words in upper case, with no separator: `AMR`.

`for w in $1; do ... ${w:0:1}` goes through the words (the unquoted `$1` is split at the blanks) and takes the first character.
