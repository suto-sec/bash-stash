#!/bin/bash
dry=
if [[ $1 == -n ]]; then dry=1; shift; fi
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 [-n] file.tgz [kb]" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
tar -tzf "$1" >/dev/null 2>&1 || { echo "Error: $1 is not a gzip tar archive" >&2; exit 4; }
kb=${2:-8}
[[ $kb =~ ^[0-9]+$ ]] && (( kb >= 1 )) || { echo "Error: $kb is not a positive integer" >&2; exit 5; }
limit=$((kb * 1024))
tgz=$(realpath "$1")
tmp=$(mktemp -d)
tar -xzf "$tgz" -C "$tmp"
n=0
while IFS= read -r -d '' f; do
  n=$((n + 1))
  [[ -n $dry ]] && echo "would remove ${f#"$tmp"/}"
done < <(find "$tmp" -type f -size +${limit}c -print0)
if [[ -n $dry ]]; then
  echo "Would remove $n files"
else
  find "$tmp" -type f -size +${limit}c -delete
  tar -czf "$tgz" -C "$tmp" .
  echo "Removed $n files"
fi
rm -rf "$tmp"
