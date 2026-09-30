#!/bin/bash
# clasifica_arbol.sh DIR
[ $# -eq 1 ] || { echo "usage: $(basename "$0") DIR" >&2; exit 1; }
D=$1
[ -d "$D" ] || { echo "error: '$D' is not a directory" >&2; exit 2; }

declare -A CNT SZ
F=0; TS=0
while IFS= read -r -d '' f; do
  case $f in
    *.sh) c=scripts ;;
    *.txt | *.md) c=docs ;;
    *.jpg | *.png) c=imagenes ;;
    *) c=otros ;;
  esac
  sz=$(stat -c %s "$f")
  CNT[$c]=$(( ${CNT[$c]:-0} + 1 ))
  SZ[$c]=$(( ${SZ[$c]:-0} + sz ))
  F=$((F + 1)); TS=$((TS + sz))
done < <(find "$D" -type f -print0 | sort -z)
for c in "${!CNT[@]}"; do echo "$c: ${CNT[$c]} archivos, ${SZ[$c]} bytes"; done | sort
echo "TOTAL: $F archivos, $TS bytes"
