#!/bin/bash
# blocklist.sh LOG WHITELIST [THRESHOLD] - add brute-force IPs to ~/blocklist.txt
usage() { echo "Usage: $(basename "$0") LOG WHITELIST [THRESHOLD]" >&2; }
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Error: wrong number of arguments" >&2; usage; exit 1
fi
LOG=$1
WL=$2
T=${3:-5}
[ -r "$LOG" ] || { echo "Error: cannot read log '$LOG'" >&2; exit 2; }
[ -r "$WL" ] || { echo "Error: cannot read whitelist '$WL'" >&2; exit 3; }
[[ $T =~ ^[0-9]+$ ]] && [ "$T" -gt 0 ] || { echo "Error: THRESHOLD must be a positive integer" >&2; exit 4; }

BL=$HOME/blocklist.txt
NEW=0; OLD=0; WHITE=0
while read -r n ip; do
  [ "$n" -ge "$T" ] || continue
  if grep -qxF -- "$ip" "$WL"; then
    echo "whitelisted $ip ($n failures)"; WHITE=$((WHITE + 1))
  elif [ -f "$BL" ] && grep -qxF -- "$ip" "$BL"; then
    echo "already listed $ip"; OLD=$((OLD + 1))
  else
    echo "$ip" >> "$BL"
    echo "blocked $ip ($n failures)"; NEW=$((NEW + 1))
  fi
done < <(grep 'Failed password' "$LOG" | sed -E 's/.* from ([0-9.]+) .*/\1/' | sort | uniq -c | sort -k1,1nr -k2)
echo "Blocked $NEW new IPs ($OLD already listed, $WHITE whitelisted)"

