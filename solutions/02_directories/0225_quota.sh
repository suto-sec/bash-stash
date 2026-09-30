#!/bin/bash
# cuota.sh DIR LIMIT - subdirectories of DIR bigger than LIMIT
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") DIR LIMIT[K|M]" >&2
  exit 1
fi
DIR=$1 LIMIT=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
if [[ $LIMIT =~ ^([0-9]+)([KM]?)$ ]] && [ "${BASH_REMATCH[1]}" -gt 0 ]; then
  L=${BASH_REMATCH[1]}
  [ "${BASH_REMATCH[2]}" = M ] && L=$((L * 1024))
else
  echo "Error: invalid limit '$LIMIT'" >&2
  exit 3
fi

N=0 M=0
for d in "$DIR"/*/; do
  [ -d "$d" ] || continue
  S=$(du -sk "$d" | cut -f1)
  if [ "$S" -gt "$L" ]; then STATE=OVER; N=$((N + 1)); else STATE=ok; fi
  echo "$(basename "$d"): $S KiB $STATE"
  M=$((M + 1))
done
echo "$N of $M directories over the limit ($L KiB)"
