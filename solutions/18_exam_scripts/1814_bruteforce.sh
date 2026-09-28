#!/bin/bash
[ $# -le 2 ] || { echo "Usage: $(basename "$0") [LOG] [THRESHOLD]" >&2; exit 4; }
LOG=${1:-/var/log/auth.log}
T=${2:-10}
[ -r "$LOG" ] || { echo "Error: cannot read $LOG" >&2; exit 2; }
[[ $T =~ ^[0-9]+$ ]] && [ "$T" -gt 0 ] || { echo "Error: THRESHOLD must be a positive integer" >&2; exit 3; }
R=$(grep 'Failed password' "$LOG" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c |
    while read -r n ip; do [ "$n" -ge "$T" ] && echo "$ip $n"; done | sort -k2,2nr -k1,1)
[ -z "$R" ] && { echo "No suspicious IPs"; exit 1; }
echo "$R"

