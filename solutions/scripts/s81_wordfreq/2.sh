#!/bin/bash
top=${2:-5}
tr -cs 'A-Za-z' '\n' < "$1" | tr 'A-Z' 'a-z' | sort | uniq -c | sort -k1,1nr -k2,2 | head -n "$top" | while read -r n w; do echo "$w: $n"; done
exit 0
