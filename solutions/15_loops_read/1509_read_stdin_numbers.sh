#!/bin/bash
n=0; s=0
while read -r x && [ "$x" != 0 ]; do
  s=$((s + x)); n=$((n + 1))
done
if [ $n -eq 0 ]; then echo "no data"; else echo "count=$n avg=$((s / n))"; fi

