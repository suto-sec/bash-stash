#!/bin/bash
declare -A n
while read -r ip _; do
  [[ -n $ip ]] && n[$ip]=$(( ${n[$ip]:-0} + 1 ))
done < "$1"
for ip in "${!n[@]}"; do echo "$ip ${n[$ip]}"; done | sort -k2,2nr -k1,1 | while read -r ip c; do echo "$ip: $c"; done
exit 0
