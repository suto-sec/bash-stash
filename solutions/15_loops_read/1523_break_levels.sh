#!/bin/bash
r=0; total=0
while read -ra nums; do
  r=$((r + 1)); s=0; fin=
  for x in "${nums[@]}"; do
    [ "$x" = FIN ] && { fin=1; break; }
    [ "$x" -lt 0 ] && continue
    [ "$x" -eq 0 ] && break
    s=$((s + x))
  done
  echo "row $r: $s"
  total=$((total + s))
  [ -n "$fin" ] && break
done < matriz.txt
echo "rows: $r, total: $total"

