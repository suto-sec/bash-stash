#!/bin/bash
# replace.sh WORD REPLACEMENT DIR - replace WORD in every *.txt file under DIR

if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") WORD REPLACEMENT DIR" >&2
  exit 1
fi
for v in "$1" "$2"; do
  if [[ ! $v =~ ^[A-Za-z0-9_]+$ ]]; then
    echo "Error: '$v' must contain only letters, digits and _" >&2
    exit 2
  fi
done
[ -d "$3" ] || { echo "Error: '$3' is not a directory" >&2; exit 3; }

T=0 M=0
while IFS= read -r -d '' f; do
  n=$(grep -o -- "$1" "$f" | wc -l)
  sed -i "s/$1/$2/g" "$f"
  echo "$f: $n replacements"
  T=$((T + n)); M=$((M + 1))
done < <(find "$3" -type f -name '*.txt' -print0 | xargs -0 -r grep -lZ -- "$1" | sort -z)

echo "Replaced $T occurrences in $M files"

