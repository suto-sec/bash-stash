Write `pad.sh FILE`. It prints every line of `FILE` preceded by its line number written with **3 digits** (`001`, `002`, ...) and a space: `001 first line`. Blank lines are numbered too and keep the number only (`003 ` with a trailing space is fine: trailing blanks are ignored by the checker).

`printf '%03d %s\n' "$n" "$line"` formats the number; read with `while IFS= read -r line` to keep the spaces.
