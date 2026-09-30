#!/bin/bash
# stats_col.sh FILE COL
[ $# -eq 2 ] || { echo "usage: $(basename "$0") FILE COL" >&2; exit 1; }
F=$1; COL=$2
[ -f "$F" ] && [ -r "$F" ] || { echo "error: cannot read '$F'" >&2; exit 2; }

read -ra head < "$F"
idx=-1
if [[ $COL =~ ^[0-9]+$ ]]; then
  (( 10#$COL >= 1 && 10#$COL <= ${#head[@]} )) && idx=$((10#$COL - 1))
else
  for ((i = 0; i < ${#head[@]}; i++)); do
    [ "${head[i]}" = "$COL" ] && { idx=$i; break; }
  done
fi
[ $idx -ge 0 ] || { echo "error: no column '$COL'" >&2; exit 3; }

n=0; sum=0; skip=0; min=; max=
while read -ra f; do
  v=${f[idx]}
  if [[ ! $v =~ ^[0-9]+$ ]]; then skip=$((skip + 1)); continue; fi
  v=$((10#$v))
  n=$((n + 1)); sum=$((sum + v))
  [ -z "$min" ] || [ $v -lt $min ] && min=$v
  [ -z "$max" ] || [ $v -gt $max ] && max=$v
done < <(tail -n +2 "$F")

echo "column: ${head[idx]}"
echo "count: $n"
if [ $n -eq 0 ]; then echo "skipped: $skip"; exit 4; fi
echo "min: $min"
echo "max: $max"
echo "sum: $sum"
a=$((sum * 100 / n))
printf 'avg: %d.%02d\n' $((a / 100)) $((a % 100))
echo "skipped: $skip"

