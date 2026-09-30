#!/bin/bash
# renumera.sh DIR EXT PREFIX
[ $# -eq 3 ] || { echo "usage: $(basename "$0") DIR EXT PREFIX" >&2; exit 1; }
D=$1 EXT=$2 P=$3
[ -d "$D" ] || { echo "error: '$D' is not a directory" >&2; exit 2; }
[[ $EXT =~ ^[a-z0-9]+$ ]] || { echo "error: bad extension '$EXT'" >&2; exit 3; }
[[ $P =~ ^[A-Za-z0-9_]+$ ]] || { echo "error: bad prefix '$P'" >&2; exit 4; }

n=0; num=1
for f in "$D"/*."$EXT"; do
  [ -f "$f" ] || continue
  b=${f##*/}
  [[ $b == "$P"-[0-9][0-9][0-9]."$EXT" ]] && continue
  until [ ! -e "$D/$(printf '%s-%03d.%s' "$P" $num "$EXT")" ]; do num=$((num + 1)); done
  new=$(printf '%s-%03d.%s' "$P" $num "$EXT")
  mv "$f" "$D/$new"
  echo "$b -> $new"
  n=$((n + 1))
done
echo "renamed $n files"
