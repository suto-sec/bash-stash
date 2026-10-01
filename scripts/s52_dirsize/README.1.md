Write `dirsize.sh DIR...`. For each directory print `DIR: N entries`, where `N` is how many entries it contains (files, directories and hidden entries; not `.` and `..`). Always the plural.

`ls -A "$d" | wc -l`.
