#!/bin/bash
# dia.sh DAY [LOG] - summary of one day of auth.log
[ $# -ge 1 ] && [ $# -le 2 ] || { echo "Usage: $(basename "$0") DAY [LOG]" >&2; exit 1; }
DAY=$1
LOG=${2:-/var/log/auth.log}
[[ $DAY =~ ^[1-9][0-9]?$ ]] && [ "$DAY" -le 31 ] || { echo "Error: invalid day '$DAY'" >&2; exit 2; }
[ -r "$LOG" ] || { echo "Error: cannot read $LOG" >&2; exit 3; }

L=$(grep -E "^[A-Za-z]{3} +$DAY " "$LOG")
[ -n "$L" ] || { echo "no entries for day $DAY" >&2; exit 4; }

FAILED=$(echo "$L" | grep 'Failed password')
echo "lines: $(echo "$L" | wc -l)"
echo "failed: $(echo "$L" | grep -c 'Failed password')"
echo "accepted: $(echo "$L" | grep -c 'Accepted ')"
echo "sudo: $(echo "$L" | grep -c 'COMMAND=')"
echo "attackers: $(echo "$FAILED" | grep ' from ' | sed -E 's/.* from ([^ ]+) .*/\1/' | sort -u | grep -c .)"
echo "first: $(echo "$L" | head -n 1 | tr -s ' ' | cut -d' ' -f3)"
echo "last: $(echo "$L" | tail -n 1 | tr -s ' ' | cut -d' ' -f3)"

