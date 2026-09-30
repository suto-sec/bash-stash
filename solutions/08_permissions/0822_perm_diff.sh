#!/bin/bash
# perm_diff.sh DIR1 DIR2 - compare the permissions of the files of two trees
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") DIR1 DIR2" >&2; exit 2; }
for d in "$1" "$2"; do
  [ -d "$d" ] || { echo "Error: '$d' is not a directory" >&2; exit 3; }
done
D1=$1 D2=$2

rel_files() { (cd "$1" && find . -type f | sed 's#^\./##'); }

diff=0 only1=0 only2=0
while IFS= read -r p; do
  if [ -f "$D1/$p" ] && [ -f "$D2/$p" ]; then
    m1=$(stat -c %a "$D1/$p") m2=$(stat -c %a "$D2/$p")
    if [ "$m1" != "$m2" ]; then echo "DIFF $p: $m1 $m2"; diff=$((diff + 1)); fi
  elif [ -f "$D1/$p" ]; then
    echo "ONLY1 $p"; only1=$((only1 + 1))
  else
    echo "ONLY2 $p"; only2=$((only2 + 1))
  fi
done < <({ rel_files "$D1"; rel_files "$D2"; } | sort -u)

echo "Summary: $diff different, $only1 only in DIR1, $only2 only in DIR2"
[ $((diff + only1 + only2)) -eq 0 ]

