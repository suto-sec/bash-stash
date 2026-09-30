#!/bin/bash
# shells.sh [passwd_file] - users per login shell
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [passwd_file]" >&2; exit 2; }
PW=${1:-/etc/passwd}
[ -f "$PW" ] && [ -r "$PW" ] || { echo "Error: cannot read $PW" >&2; exit 1; }

cut -d: -f7 "$PW" | sort | uniq -c | sort -k1,1nr -k2 | while read -r n shell; do
  echo "$shell: $n users"
done
echo "Total: $(wc -l < "$PW") users, $(cut -d: -f7 "$PW" | sort -u | wc -l) shells"

