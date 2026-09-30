#!/bin/bash
echo "lines: $(grep -ciw kernel texto.txt)"
echo "occurrences: $(grep -oiw kernel texto.txt | wc -l)"
MAX=$(grep -noiw kernel texto.txt | cut -d: -f1 | uniq -c | sort -rn | head -n 1)
set -- $MAX
echo "max: ${1:-0}"

