#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
n=0 bad=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f"); low=${name,,}
  [[ $name == "$low" ]] && continue
  if [[ -e $1/$low ]]; then echo "skipped $name" >&2; bad=1; continue; fi
  mv -- "$f" "$1/$low"; n=$((n + 1))
done
echo "Renamed $n files"
(( bad == 0 )) || exit 4
