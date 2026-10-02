#!/bin/bash
if (( $# != 1 )); then echo "Error: one argument needed" >&2; echo "Usage: $0 file.tgz" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
list=$(tar -tzf "$1" 2>/dev/null) || { echo "Error: $1 is not a gzip tar archive" >&2; exit 4; }
total=$(echo "$list" | grep -c .)
dirs=$(echo "$list" | grep -c '/$')
echo "Entries: $total"
echo "Directories: $dirs"
echo "Files: $((total - dirs))"
big=$(tar -tzvf "$1" | awk '$1 ~ /^-/ {print $3, $6}' | sort -k1,1nr | head -n 1)
if [[ -z $big ]]; then echo "Largest: none"; else echo "Largest: ${big#* } (${big%% *} bytes)"; fi
