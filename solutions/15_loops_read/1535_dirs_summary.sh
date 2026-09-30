#!/bin/bash
# resumen_dirs.sh DIR...
[ $# -ge 1 ] || { echo "usage: $(basename "$0") DIR..." >&2; exit 1; }
N=0; TF=0; TS=0; rc=0
for d in "$@"; do
  if [ ! -d "$d" ]; then echo "not a directory: $d" >&2; rc=2; continue; fi
  f=0; s=0; big=none; bs=-1
  while IFS= read -r -d '' p; do
    sz=$(stat -c %s "$p")
    f=$((f + 1)); s=$((s + sz))
    [ "$sz" -gt $bs ] && { bs=$sz; big=$p; }
  done < <(find "$d" -type f -print0 | sort -z)
  nd=$(find "$d" -mindepth 1 -type d | wc -l)
  echo "$d: $f files, $nd dirs, $s bytes, largest: $big"
  N=$((N + 1)); TF=$((TF + f)); TS=$((TS + s))
done
echo "TOTAL: $N dirs, $TF files, $TS bytes"
exit $rc

