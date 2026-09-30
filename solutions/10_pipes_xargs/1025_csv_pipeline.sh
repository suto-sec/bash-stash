#!/bin/bash
tail -n +2 ventas.csv | sort -t, -k3,3nr -k1,1 | head -n 3 | cut -d, -f1,3 | tr , ' '
echo ---
tail -n +2 ventas.csv | cut -d, -f2 | sort | uniq -c | sed -E 's/^ *([0-9]+) (.*)$/\2: \1/'
echo ---
tail -n +2 ventas.csv | cut -d, -f1 | sort -u | wc -l

