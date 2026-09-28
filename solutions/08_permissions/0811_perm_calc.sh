#!/bin/bash
p=$1
if [[ ! $p =~ ^[r-][w-][x-][r-][w-][x-][r-][w-][x-]$ ]]; then
  echo "Usage: $0 PERMS  (e.g. rwxr-x---)" >&2
  exit 1
fi
out=
for i in 0 3 6; do
  n=0
  [[ ${p:i:1} == r ]] && n=$((n + 4))
  [[ ${p:i+1:1} == w ]] && n=$((n + 2))
  [[ ${p:i+2:1} == x ]] && n=$((n + 1))
  out+=$n
done
echo "$out"

