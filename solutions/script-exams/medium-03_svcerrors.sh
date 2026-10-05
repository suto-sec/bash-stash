#!/bin/bash
usage() { echo "Usage: $0 file [level]" >&2; }
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; usage; exit 1; fi
file=$1 level=${2:-ERROR}
[[ -f $file ]] || { echo "Error: $file does not exist or is not a regular file" >&2; exit 2; }
[[ -r $file ]] || { echo "Error: cannot read $file" >&2; exit 4; }
case $level in
  INFO|WARN|ERROR) ;;
  *) echo "Error: invalid level '$level'" >&2; exit 3 ;;
esac
total=0
while read -r n svc; do
  [[ -n $svc ]] || continue
  echo "$svc: $n"
  total=$((total + n))
done < <(awk -v lv="$level" '$3 == lv && $4 ~ /^[a-z0-9-]+:$/ { print substr($4, 1, length($4) - 1) }' "$file" | sort | uniq -c | sort -k1,1nr -k2,2)
echo "Total: $total"
