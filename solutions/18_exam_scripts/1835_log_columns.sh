#!/bin/bash
# log_columns.sh LOGFILE
usage() { echo "Usage: $(basename "$0") LOGFILE" >&2; }
[ $# -eq 1 ] || { usage; exit 1; }
LOG=$1
[ -f "$LOG" ] && [ -r "$LOG" ] || { echo "Error: cannot read '$LOG'" >&2; exit 2; }
cut -d' ' -f2 "$LOG" | sort | uniq -c | sort -k1,1nr -k2,2 | while read -r c lvl; do echo "$lvl $c"; done
N=$(wc -l < "$LOG")
echo "Total: $N lines"

