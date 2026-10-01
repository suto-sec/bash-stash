# 0716 · Counting by extension

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find, sed/rev, sort, uniq -c

Under `repo`, count the regular files **by extension** (the part after the last `.` of the name;
files without a dot are ignored). Print as `uniq -c` does, sorted by count descending and then by
extension alphabetically.

Hint: `find repo -type f -name '*.*'` + extract the extension (e.g. `sed 's/.*\.//'`).
