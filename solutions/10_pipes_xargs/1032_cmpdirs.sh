#!/bin/bash
# cmpdirs.sh DIR1 DIR2 - compare the regular files of two trees

if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") DIR1 DIR2" >&2
  exit 2
fi
for d in "$1" "$2"; do
  [ -d "$d" ] || { echo "Error: '$d' is not a directory" >&2; exit 3; }
done

rel() { (cd "$1" && find . -type f) | sed 's#^\./##' | sort; }

ONLY1=$(comm -23 <(rel "$1") <(rel "$2"))
ONLY2=$(comm -13 <(rel "$1") <(rel "$2"))
S=0 D=0 DIFF=""
while IFS= read -r f; do
  [ -z "$f" ] && continue
  if cmp -s "$1/$f" "$2/$f"; then S=$((S + 1)); else D=$((D + 1)); DIFF+="* $f"$'\n'; fi
done < <(comm -12 <(rel "$1") <(rel "$2"))

A=$(echo -n "$ONLY1" | grep -c '^')
B=$(echo -n "$ONLY2" | grep -c '^')
[ -n "$ONLY1" ] && echo "$ONLY1" | sed 's/^/- /'
[ -n "$ONLY2" ] && echo "$ONLY2" | sed 's/^/+ /'
echo -n "$DIFF"
echo "$S identical, $D different, $A only in $1, $B only in $2"
[ $((A + B + D)) -eq 0 ]

