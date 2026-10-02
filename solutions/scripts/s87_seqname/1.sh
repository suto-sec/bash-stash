#!/bin/bash
n=1
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
