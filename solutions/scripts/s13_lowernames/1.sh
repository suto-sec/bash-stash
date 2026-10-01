#!/bin/bash
n=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f"); low=${name,,}
  if [[ $name != "$low" ]]; then mv -- "$f" "$1/$low"; n=$((n + 1)); fi
done
echo "Renamed $n files"
