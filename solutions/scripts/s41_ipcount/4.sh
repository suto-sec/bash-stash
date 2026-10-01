#!/bin/bash
prefix=
if [[ $1 == -f ]]; then
  if (( $# < 3 )); then echo "Error: -f needs a prefix and a log" >&2; echo "Usage: $0 [-f prefix] log [N]" >&2; exit 1; fi
  prefix=$2; shift 2
fi
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 [-f prefix] log [N]" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
top=${2:-3}
[[ $top =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$top' is not a positive integer" >&2; exit 3; }
declare -A n
while read -r ip _; do
  [[ -n $ip && $ip == "$prefix"* ]] && n[$ip]=$(( ${n[$ip]:-0} + 1 ))
done < "$1"
for ip in "${!n[@]}"; do echo "$ip ${n[$ip]}"; done | sort -k2,2nr -k1,1 | head -n "$top" | while read -r ip c; do echo "$ip: $c"; done
exit 0
