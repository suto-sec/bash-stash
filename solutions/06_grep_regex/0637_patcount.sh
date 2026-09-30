#!/bin/bash
# patcount.sh PATTERNS FILE
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") PATTERNS FILE" >&2
  exit 1
fi
PF=$1
F=$2
[ -r "$PF" ] || { echo "Error: cannot read patterns file '$PF'" >&2; exit 2; }
[ -r "$F" ] || { echo "Error: cannot read '$F'" >&2; exit 3; }

P=0 M=0
while IFS= read -r p; do
  [ -z "$p" ] && continue
  [[ $p == \#* ]] && continue
  n=$(grep -ciF -e "$p" "$F")
  echo "$p: $n"
  P=$((P + 1))
  [ "$n" -gt 0 ] && M=$((M + 1))
done < "$PF"
echo "$M of $P patterns found"
[ $M -gt 0 ] || exit 4
