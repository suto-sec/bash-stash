#!/bin/bash
# limpiar_tmp.sh DIR
[ $# -eq 1 ] || { echo "usage: $(basename "$0") DIR" >&2; exit 1; }
D=$1
[ -e "$D" ] || { echo "error: '$D' does not exist" >&2; exit 2; }
[ -d "$D" ] || { echo "error: '$D' is not a directory" >&2; exit 3; }

R=0; L=0
while IFS= read -r -d '' f; do
  sz=$(stat -c %s "$f")
  rm -- "$f"
  echo "borrado: $f ($sz bytes)"
  R=$((R + 1)); L=$((L + sz))
done < <(find "$D" -type f \( -name '*.tmp' -o -name '*.bak' \) -print0 | sort -z)
echo "TOTAL: borrados $R archivos, $L bytes liberados"

