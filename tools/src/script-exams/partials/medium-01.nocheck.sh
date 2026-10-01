#!/bin/bash
# expect: 6..8
# the whole report works, but no argument is checked at all
file=$1 thr=${2:-5}
rows=$(tail -n +2 "$file" | grep -v '^$' | while IFS=, read -r item qty price; do
  (( qty < thr )) && echo "$qty,$item,$((qty * price))"
done | sort -t, -k1,1n -k2,2)
[[ -n $rows ]] && echo "$rows" | while IFS=, read -r q i v; do echo "$i: $q"; done
echo "Low stock items: $(echo -n "$rows" | grep -c .)"
echo "Total value: $(echo "$rows" | awk -F, '{ s += $3 } END { print s + 0 }')"
