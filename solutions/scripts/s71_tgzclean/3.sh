#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 file.tgz [kb]" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
tar -tzf "$1" >/dev/null 2>&1 || { echo "Error: $1 is not a gzip tar archive" >&2; exit 4; }
kb=${2:-8}
[[ $kb =~ ^[0-9]+$ ]] && (( kb >= 1 )) || { echo "Error: $kb is not a positive integer" >&2; exit 5; }
limit=$((kb * 1024))
tgz=$(realpath "$1")
tmp=$(mktemp -d)
tar -xzf "$tgz" -C "$tmp"
n=$(find "$tmp" -type f -size +${limit}c | wc -l)
find "$tmp" -type f -size +${limit}c -delete
tar -czf "$tgz" -C "$tmp" .
rm -rf "$tmp"
echo "Removed $n files"
