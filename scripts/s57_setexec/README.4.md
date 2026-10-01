Print `ok NAME` only when the file **was not already executable** for that class (the owner, or everybody with `-a`); when nothing needed changing print `unchanged NAME` instead. Finish with `Changed N files`. "Executable for everybody" means the three execute bits are set.

`[[ -x file ]]` tests the owner's bit (for the user running the script); for `-a` check the mode with `stat -c %a`.
