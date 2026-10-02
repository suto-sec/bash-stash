#!/bin/bash
if (( $# < 2 || $# > 3 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 dir prefix [start]" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -z $2 || $2 == */* ]]; then echo "Error: bad prefix '$2'" >&2; exit 4; fi
n=${3:-1}
[[ $n =~ ^[0-9]+$ ]] || { echo "Error: $n is not a valid start number" >&2; exit 5; }
n=$((10#$n))
while IFS= read -r f; do
  [[ -f $1/$f ]] || continue
  ext=
  [[ $f == *.* ]] && ext=.${f##*.}
  new=$(printf '%s-%03d%s' "$2" "$n" "$ext")
  mv -- "$1/$f" "$1/$new"
  echo "$f -> $new"
  n=$((n + 1))
done < <(ls "$1")
exit 0
