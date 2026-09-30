#!/bin/bash
bytes() { od -An -v -tu1 "$1" | tr -s ' ' '\n' | sed '/^$/d'; }
bytes "$1" | sort -n | uniq -c | sort -k1,1nr -k2,2n | head -n 5 | sed -E 's/^ *([0-9]+) ([0-9]+)$/\2 \1/'
echo "distinct: $(bytes "$1" | sort -u | wc -l)"

