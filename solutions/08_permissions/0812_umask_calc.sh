#!/bin/bash
sym() { # octal digits -> rwx string
  local o=$1 s= d
  for ((k = 0; k < 3; k++)); do
    d=${o:k:1}
    (( d & 4 )) && s+=r || s+=-
    (( d & 2 )) && s+=w || s+=-
    (( d & 1 )) && s+=x || s+=-
  done
  echo "$s"
}
f=$(printf '%03o' $(( 8#666 & ~8#$1 )))
d=$(printf '%03o' $(( 8#777 & ~8#$1 )))
echo "file: $f $(sym "$f")"
echo "dir: $d $(sym "$d")"
