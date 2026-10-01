#!/bin/bash
n=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f"); low=${name,,}
  [[ $name == "$low" ]] && continue
  if [[ -e $1/$low ]]; then echo "skipped $name" >&2; continue; fi
  mv -- "$f" "$1/$low"; n=$((n + 1))
done
echo "Renamed $n files"
