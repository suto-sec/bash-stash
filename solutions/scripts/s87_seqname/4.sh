#!/bin/bash
if (( $# < 2 || $# > 3 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 dir prefix [start]" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -z $2 || $2 == */* ]]; then echo "Error: bad prefix '$2'" >&2; exit 4; fi
n=${3:-1}
[[ $n =~ ^[0-9]+$ ]] || { echo "Error: $n is not a valid start number" >&2; exit 5; }
n=$((10#$n))
files=() news=()
while IFS= read -r f; do
  [[ -f $1/$f ]] || continue
  ext=
  [[ $f == *.* ]] && ext=.${f##*.}
  files+=("$f"); news+=("$(printf '%s-%03d%s' "$2" "$n" "$ext")")
  n=$((n + 1))
done < <(ls "$1")
bad=0
for new in "${news[@]}"; do
  if [[ -e $1/$new ]]; then echo "exists: $new" >&2; bad=1; fi
done
(( bad == 0 )) || exit 6
for i in "${!files[@]}"; do
  mv -- "$1/${files[i]}" "$1/${news[i]}"
  echo "${files[i]} -> ${news[i]}"
done
exit 0
