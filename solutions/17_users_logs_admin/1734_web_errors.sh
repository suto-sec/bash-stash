#!/bin/bash
# weberrors.sh [LOG] [N] - paths with most 4xx/5xx responses
[ $# -le 2 ] || { echo "Usage: $(basename "$0") [LOG] [N]" >&2; exit 1; }
LOG=${1:-/var/log/apache2/access.log}
N=${2:-5}
[ -r "$LOG" ] || { echo "Error: cannot read $LOG" >&2; exit 2; }
[[ $N =~ ^[0-9]+$ ]] && [ "$N" -gt 0 ] || { echo "Error: N must be a positive integer" >&2; exit 3; }
R=$(wc -l < "$LOG")
[ "$R" -gt 0 ] || { echo "Error: $LOG is empty" >&2; exit 4; }

# "ip path" of every error request
ERR=$(cut -d' ' -f1,7,9 "$LOG" | while read -r ip path code; do
  [ "$code" -ge 400 ] && echo "$ip $path"
done)
E=0
if [ -n "$ERR" ]; then
  E=$(echo "$ERR" | wc -l)
  echo "$ERR" | cut -d' ' -f2 | sort | uniq -c | sort -k1,1nr -k2 | head -n "$N" |
  while read -r n path; do
    k=$(echo "$ERR" | while read -r ip p; do [ "$p" = "$path" ] && echo "$ip"; done | sort -u | wc -l)
    echo "$n $path ($k IPs)"
  done
fi
echo "Errors: $E of $R requests ($((E * 100 / R))%)"

