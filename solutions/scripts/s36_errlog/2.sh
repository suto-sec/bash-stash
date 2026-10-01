#!/bin/bash
out=$HOME/reports/errors.txt
grep ' ERROR ' "$1" > "$out"
echo "Saved $(wc -l < "$out") errors to $out"
