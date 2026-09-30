#!/bin/bash
# dup_files.sh DIR
if [ $# -ne 1 ]; then
  echo "usage: $(basename "$0") DIR" >&2
  exit 1
fi
D=$1
if [ ! -e "$D" ]; then
  echo "error: '$D' does not exist" >&2
  exit 2
fi
if [ ! -d "$D" ]; then
  echo "error: '$D' is not a directory" >&2
  exit 3
fi

kept=()
n=0; dup=0
while IFS= read -r -d '' f; do
  n=$((n + 1))
  sz=$(stat -c %s "$f")
  match=
  for k in "${kept[@]}"; do
    [ "$(stat -c %s "$k")" -eq "$sz" ] || continue
    if cmp -s "$f" "$k"; then match=$k; break; fi
  done
  if [ -n "$match" ]; then
    echo "DUP: $f == $match"
    dup=$((dup + 1))
  else
    kept+=("$f")
  fi
done < <(find "$D" -type f -print0 | sort -z)
echo "TOTAL: $n files, ${#kept[@]} unicos, $dup duplicados"

