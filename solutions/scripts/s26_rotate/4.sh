#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 file [keep]" >&2; exit 1; fi
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 2; }
keep=${2:-3}
[[ $keep =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$keep' is not a positive integer" >&2; exit 3; }
for g in "$1".[0-9]*; do
  [[ -e $g ]] || continue
  n=${g##*.}
  [[ $n =~ ^[0-9]+$ ]] && (( n >= keep )) && rm -f -- "$g"
done
n=1
while [[ -e $1.$n ]]; do n=$((n + 1)); done
for ((i = n - 1; i >= 1; i--)); do
  mv -- "$1.$i" "$1.$((i + 1))"
done
cp -- "$1" "$1.1"
: > "$1"
echo "Rotated $1"
