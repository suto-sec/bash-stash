Write `lowernames.sh DIR`. Every **regular file directly inside** `DIR` is renamed to its lower-case name (`NOTES.txt` becomes `notes.txt`); files already in lower case stay as they are. Subdirectories are not touched. Print `Renamed N files` (N = how many were renamed). Names may contain spaces.

`${name,,}` is `name` in lower case; `mv -- "$old" "$new"` renames. Assume no new name collides with an existing file in this step.
