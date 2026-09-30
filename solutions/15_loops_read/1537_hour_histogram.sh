#!/bin/bash
# histograma.sh LOG [LEVEL]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then echo "usage: $(basename "$0") LOG [LEVEL]" >&2; exit 1; fi
LOG=$1; LEVEL=${2^^}
[ -f "$LOG" ] && [ -r "$LOG" ] || { echo "error: cannot read '$LOG'" >&2; exit 2; }
if [ $# -eq 2 ] && [[ ! $LEVEL =~ ^(INFO|WARN|ERROR)$ ]]; then
  echo "error: unknown level '$2'" >&2; exit 3
fi

c=(); M=0; T=0
while read -r date time lvl rest; do
  if [[ ! $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ || ! $time =~ ^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$ ||
        ! $lvl =~ ^(INFO|WARN|ERROR)$ ]]; then
    M=$((M + 1)); continue
  fi
  [ -n "$LEVEL" ] && [ "$lvl" != "$LEVEL" ] && continue
  h=$((10#${time:0:2}))
  c[h]=$(( ${c[h]:-0} + 1 ))
  T=$((T + 1))
done < "$LOG"

H=0; best=-1
for ((h = 0; h < 24; h++)); do
  n=${c[h]:-0}
  [ $n -eq 0 ] && continue
  bar=; for ((i = 0; i < n; i++)); do bar+='#'; done
  printf '%02d %3d %s\n' $h $n "$bar"
  H=$((H + 1))
  [ $n -gt $best ] && { best=$n; bh=$h; }
done
[ $T -gt 0 ] && printf 'busiest: %02d (%d)\n' $bh $best
echo "total: $T entries, $H hours, $M malformed"

