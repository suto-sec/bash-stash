#!/bin/bash
# niveles.sh DIR [MAX] - directories and files per depth level
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") DIR [MAX]" >&2
  exit 1
fi
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
if [ $# -eq 2 ]; then
  if ! [[ $2 =~ ^[0-9]+$ ]] || [ $((10#$2)) -lt 1 ]; then
    echo "Error: MAX must be a positive integer" >&2
    exit 3
  fi
  MAX=$((10#$2))
fi

DEEP=$(find "$DIR" -mindepth 1 \( -type d -o -type f \) -printf '%d\n' | sort -n | tail -n 1)
DEEP=${DEEP:-0}
LIM=$DEEP
[ -n "$MAX" ] && [ "$MAX" -lt "$LIM" ] && LIM=$MAX

TD=0
TF=0
for ((l = 1; l <= LIM; l++)); do
  d=$(find "$DIR" -mindepth $l -maxdepth $l -type d | wc -l)
  f=$(find "$DIR" -mindepth $l -maxdepth $l -type f | wc -l)
  echo "level $l: $d dirs, $f files"
  TD=$((TD + d))
  TF=$((TF + f))
done
echo "Deepest level: $DEEP"
echo "Total: $TD dirs, $TF files"

