#!/bin/bash
# domains.sh FILE...
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") FILE..." >&2
  exit 1
fi
RE='[A-Za-z0-9._+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}'
RC=0
FILES=()
for f in "$@"; do
  if [ -f "$f" ] && [ -r "$f" ]; then
    FILES+=("$f")
  else
    echo "Error: cannot read '$f'" >&2
    RC=2
  fi
done

A=""
[ ${#FILES[@]} -gt 0 ] && A=$(grep -ohE "$RE" "${FILES[@]}" | tr 'A-Z' 'a-z' | sort -u)
if [ -n "$A" ]; then
  cut -d@ -f2 <<< "$A" | sort | uniq -c | sort -k1,1nr -k2,2 |
    while read -r n d; do echo "$d $n"; done
fi
NA=$(grep -c . <<< "$A")
ND=$(cut -d@ -f2 <<< "$A" | sort -u | grep -c .)
echo "$NA distinct addresses, $ND domains"
[ $RC -eq 0 ] && [ "$NA" -eq 0 ] && RC=3
exit $RC

