Write `onlyin.sh DIR1 DIR2`. It prints, **sorted**, the name of every entry of `DIR1` (files and directories, no hidden ones) that has **no entry with the same name** in `DIR2`. Only the names count (not the contents). Names may contain spaces.

Hint: `comm -23 <(ls DIR1 | sort) <(ls DIR2 | sort)`.
