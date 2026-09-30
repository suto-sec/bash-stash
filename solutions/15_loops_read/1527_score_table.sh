#!/bin/bash
n=0; sum=0; ln=0
while read -r name score extra; do
  ln=$((ln + 1))
  if [[ -z $name || -n $extra || ! $score =~ ^[0-9]+$ ]] || (( 10#$score > 100 )); then
    echo "skipped line $ln" >&2; continue
  fi
  stars=
  for ((i = 0; i < score / 10; i++)); do stars+='*'; done
  printf '%-10s %3d %s\n' "$name" "$score" "$stars"
  n=$((n + 1)); sum=$((sum + score))
done
if [ $n -eq 0 ]; then
  echo "count: 0, average: -"
else
  a=$((sum * 100 / n))
  printf 'count: %d, average: %d.%02d\n' "$n" $((a / 100)) $((a % 100))
fi

