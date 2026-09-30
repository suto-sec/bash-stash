#!/bin/bash
# subjstats.sh FILE [SUBJECT]: statistics of the grades of every subject

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE [SUBJECT]" >&2
  exit 1
fi
F=$1
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi

DATA=$(grep -v '^#' "$F" | sed '/^$/d')

if [ $# -eq 2 ]; then
  if ! echo "$DATA" | cut -d';' -f2 | grep -qxF -- "$2"; then
    echo "Error: subject '$2' not found in '$F'" >&2
    exit 3
  fi
  SUBJECTS=$2
else
  SUBJECTS=$(echo "$DATA" | cut -d';' -f2 | sed '/^$/d' | sort -u)
fi

S=0 G=0
while IFS= read -r s; do
  [ -z "$s" ] && continue
  rows=$(echo "$DATA" | grep -- "^[^;]*;$s;")
  n=$(echo "$rows" | wc -l)
  best=$(echo "$rows" | sort -t';' -k3,3nr -k1,1 | head -n 1)
  worst=$(echo "$rows" | sort -t';' -k3,3n -k1,1 | head -n 1)
  p=$(echo "$rows" | cut -d';' -f3 | grep -cE '^([5-9]|10)$')
  echo "$s: $n grades, best ${best%%;*} (${best##*;}), worst ${worst%%;*} (${worst##*;}), $p passed"
  S=$((S + 1)) G=$((G + n))
done <<< "$SUBJECTS"

echo "Subjects: $S, grades: $G"

