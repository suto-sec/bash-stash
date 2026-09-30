#!/bin/bash
# inventario.sh FILE [MIN]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "usage: $(basename "$0") FILE [MIN]" >&2; exit 1
fi
F=$1; MIN=${2:-5}
[ -f "$F" ] && [ -r "$F" ] || { echo "error: cannot read '$F'" >&2; exit 2; }
[[ $MIN =~ ^[0-9]+$ ]] || { echo "error: MIN '$MIN' is not a non-negative integer" >&2; exit 3; }

n=1; P=0; U=0; V=0; L=0; bad=0
while IFS=';' read -r prod qty price extra; do
  n=$((n + 1))
  if [ -z "$prod" ] || [ -n "$extra" ] || [[ ! $qty =~ ^[0-9]+$ || ! $price =~ ^[0-9]+$ ]]; then
    echo "line $n: invalid" >&2; bad=1; continue
  fi
  val=$((qty * price))
  low=
  if [ "$qty" -lt "$MIN" ]; then low=" (low stock)"; L=$((L + 1)); fi
  echo "$prod: $qty x $price = $val$low"
  P=$((P + 1)); U=$((U + qty)); V=$((V + val))
done < <(tail -n +2 "$F")
echo "TOTAL: $P products, $U units, $V euros, $L low"
[ $bad -eq 0 ] || exit 4

