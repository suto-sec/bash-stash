#!/bin/bash
[ $# -ge 1 ] && [ $# -le 2 ] || { echo "Usage: $(basename "$0") LOGFILE [KEEP]" >&2; exit 1; }
LOG=$1
KEEP=${2:-3}
[ -f "$LOG" ] || { echo "Error: $LOG is not a regular file" >&2; exit 2; }
[[ $KEEP =~ ^[0-9]+$ ]] && [ "$KEEP" -ge 1 ] || { echo "Error: KEEP must be >= 1" >&2; exit 3; }
rm -f "$LOG.$KEEP.gz"
for ((i = KEEP - 1; i >= 1; i--)); do
  [ -e "$LOG.$i.gz" ] && mv "$LOG.$i.gz" "$LOG.$((i + 1)).gz"
done
gzip -c "$LOG" > "$LOG.1.gz"
: > "$LOG"
echo "Rotated $LOG (keeping $KEEP)"

