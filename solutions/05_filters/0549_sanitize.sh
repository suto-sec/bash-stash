#!/bin/bash
# sanitize.sh FILE...: remove CRs, expand TABs and strip trailing spaces, in place

if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") FILE..." >&2
  exit 1
fi

N=0 FIXED=0 BAD=0
for f in "$@"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ] || [ ! -w "$f" ]; then
    echo "Error: cannot fix '$f'" >&2
    BAD=1
    continue
  fi
  N=$((N + 1))
  c=$(grep -c $'\r' "$f")
  t=$(grep -c $'\t' "$f")
  s=$(tr -d '\r' < "$f" | grep -c $'[ \t]$')
  if [ $((c + t + s)) -eq 0 ]; then
    echo "$f: clean"
    continue
  fi
  sed -i 's/\r//g; s/\t/    /g; s/ *$//' "$f"
  echo "$f: $c CR, $t tabs, $s trailing"
  FIXED=$((FIXED + 1))
done

echo "Fixed $FIXED of $N files"
[ $BAD -eq 1 ] && exit 2
exit 0

