#!/bin/bash
if (( $# != 3 )); then echo "Error: three arguments needed" >&2; echo "Usage: $0 dir old new" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
for f in "$1"/*."$2" "$1"/.*."$2"; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  new="${name%.$2}.$3"
  mv -- "$f" "$1/$new"
  echo "$name -> $new"
done
exit 0
