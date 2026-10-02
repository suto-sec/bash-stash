#!/bin/bash
if (( $# != 3 )); then echo "Error: three arguments needed" >&2; echo "Usage: $0 dir old new" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
n=0 skipped=0
for f in "$1"/*."$2" "$1"/.*."$2"; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  new="${name%.$2}.$3"
  if [[ -e $1/$new ]]; then echo "exists: $new" >&2; skipped=1; continue; fi
  mv -- "$f" "$1/$new"
  echo "$name -> $new"
  n=$((n + 1))
done
echo "Renamed $n files"
(( skipped == 0 )) || exit 4
