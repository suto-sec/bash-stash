#!/bin/bash
# expect: 4..8
# the counting is right, but no argument is checked
file=$1 level=${2:-ERROR}
total=0
while read -r n svc; do
  [[ -n $svc ]] || continue
  echo "$svc: $n"
  total=$((total + n))
done < <(awk -v lv="$level" '$3 == lv && $4 ~ /^[a-z0-9-]+:$/ { print substr($4, 1, length($4) - 1) }' "$file" | sort | uniq -c | sort -k1,1nr -k2,2)
echo "Total: $total"
