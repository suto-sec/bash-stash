#!/bin/bash
if (( $# != 2 )); then echo "Error: two files are needed" >&2; echo "Usage: $0 file1 file2" >&2; exit 1; fi
for f in "$1" "$2"; do
  [[ -f $f ]] || { echo "Error: $f is not a regular file" >&2; exit 2; }
done
if cmp -s "$1" "$2"; then echo same; exit 0; fi
echo "different: $(wc -l < "$1") lines, $(wc -l < "$2") lines"
exit 4
