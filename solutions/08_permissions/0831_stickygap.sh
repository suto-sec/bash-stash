#!/bin/bash
FIX=0
if [ "$1" = -f ]; then
  FIX=1
  shift
fi
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") [-f] DIR" >&2
  exit 2
fi
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }

n=0
while IFS= read -r p; do
  old=$(stat -c %a "$p")
  if [ $FIX -eq 1 ]; then
    chmod +t "$p"
    new=$(stat -c %a "$p")
    echo "$p: $old -> $new"
  else
    echo "$p: $old"
  fi
  n=$((n + 1))
done < <(find "$DIR" -type d -perm -0002 ! -perm -1000 | sort)

if [ $FIX -eq 1 ]; then
  echo "$n directories fixed"
else
  echo "$n directories found"
  [ $n -eq 0 ] || exit 1
fi

