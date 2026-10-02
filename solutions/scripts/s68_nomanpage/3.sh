#!/bin/bash
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 bindir mandir" >&2; exit 1; fi
for d in "$1" "$2"; do [[ -e $d ]] || { echo "Error: $d does not exist" >&2; exit 2; }; done
for d in "$1" "$2"; do [[ -d $d ]] || { echo "Error: $d is not a directory" >&2; exit 3; }; done
n=0
while IFS= read -r f; do
  [[ -e $2/$f.1.gz ]] || { echo "$f"; n=$((n + 1)); }
done < <(ls "$1")
echo "$n commands without a manual page"
