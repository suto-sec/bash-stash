#!/bin/bash
dir=$HOME/reports
if [[ ! -d $dir ]]; then mkdir -p "$dir"; echo "Directory $dir created"; fi
out=$dir/errors.txt
grep ' ERROR ' "$1" > "$out"
echo "Saved $(wc -l < "$out") errors to $out"
