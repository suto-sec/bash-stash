#!/bin/bash
if (( $# != 1 )); then echo "Error: one log file is needed" >&2; echo "Usage: $0 log" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
if ! grep -q ' ERROR ' "$1"; then echo "No errors found"; exit 0; fi
dir=$HOME/reports
if [[ ! -d $dir ]]; then mkdir -p "$dir"; echo "Directory $dir created"; fi
out=$dir/errors.txt
grep ' ERROR ' "$1" > "$out"
echo "Saved $(wc -l < "$out") errors to $out"
