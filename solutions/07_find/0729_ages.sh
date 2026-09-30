#!/bin/bash
# ages.sh DIR [DAYS] - files modified less than DAYS days ago, with their age in days
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") DIR [DAYS]" >&2
  exit 1
fi
DIR=$1
DAYS=${2:-7}
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
if ! [[ $DAYS =~ ^[0-9]+$ ]] || [ $((10#$DAYS)) -lt 1 ]; then
  echo "Error: DAYS must be a positive integer" >&2
  exit 3
fi
DAYS=$((10#$DAYS))

NOW=$(date +%s)
N=0
while read -r age path; do
  echo "$age $path"
  N=$((N + 1))
done < <(find "$DIR" -type f -mtime -"$DAYS" -exec stat -c '%Y %n' {} + |
           while read -r t f; do echo "$(( (NOW - t) / 86400 )) $f"; done | sort -k1,1n -k2)
ALL=$(find "$DIR" -type f | wc -l)
echo "$N recent files, $((ALL - N)) older"

