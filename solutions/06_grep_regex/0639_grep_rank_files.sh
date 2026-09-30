#!/bin/bash
for f in logs/*; do
  n=$(grep -ci timeout "$f")
  [ "$n" -gt 0 ] && echo "$n $f"
done | sort -k1,1nr -k2,2
echo "Total: $(cat logs/*.log | grep -ci timeout)"

