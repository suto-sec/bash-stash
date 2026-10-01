#!/bin/bash
usage() { echo "Usage: $0 file [threshold]" >&2; }
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; usage; exit 1; fi
file=$1 thr=${2:-5}
[[ -f $file ]] || { echo "Error: $file does not exist or is not a regular file" >&2; exit 2; }
[[ -r $file ]] || { echo "Error: cannot read $file" >&2; exit 4; }
[[ $thr =~ ^[1-9][0-9]*$ ]] || { echo "Error: threshold '$thr' must be a positive integer" >&2; exit 3; }
rows= n=0 total=0
{
  read -r _header
  while IFS=, read -r item qty price; do
    [[ -n $item ]] || continue
    if (( qty < thr )); then rows+="$qty,$item"$'\n'; n=$((n + 1)); total=$((total + qty * price)); fi
  done
} < "$file"
if [[ -n $rows ]]; then
  printf '%s' "$rows" | sort -t, -k1,1n -k2 | while IFS=, read -r q i; do echo "$i: $q"; done
fi
echo "Low stock items: $n"
echo "Total value: $total"
