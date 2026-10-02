#!/bin/bash
for f in "$1"/*."$2" "$1"/.*."$2"; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  new="${name%.$2}.$3"
  mv -- "$f" "$1/$new"
  echo "$name -> $new"
done
exit 0
