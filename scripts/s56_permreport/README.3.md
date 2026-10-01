A file is **world-writable** when the last octal digit of its mode has the write bit (value 2): 2, 3, 6 or 7. Add ` !` (a space and an exclamation mark) at the end of the line of those files: `666 notes.txt !`.

`mode=$(stat -c %a "$f")` and `(( ${mode: -1} & 2 ))`.
