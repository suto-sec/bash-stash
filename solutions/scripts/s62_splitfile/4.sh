#!/bin/bash
if (( $# != 2 )); then echo "Error: a file and a size are needed" >&2; echo "Usage: $0 file N" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
[[ $2 =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$2' is not a positive integer" >&2; exit 3; }
total=$(wc -l < "$1")
parts=$(( (total + $2 - 1) / $2 ))
for ((k = 1; k <= parts; k++)); do
  if [[ -e $1.part$k ]]; then echo "Error: $1.part$k already exists" >&2; exit 4; fi
done
for ((k = 1; k <= parts; k++)); do
  a=$(( (k - 1) * $2 + 1 ))
  sed -n "${a},$((a + $2 - 1))p" "$1" > "$1.part$k"
  echo "Created $1.part$k"
done
echo "Created $parts parts"
