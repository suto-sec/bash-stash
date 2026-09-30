#!/bin/bash
# wsearch.sh WORD [DIR]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") WORD [DIR]" >&2
  exit 1
fi
WORD=$1
DIR=${2:-.}
if [[ ! $WORD =~ ^[[:alnum:]]+$ ]]; then
  echo "Error: '$WORD' is not a valid word" >&2
  exit 2
fi
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory" >&2
  exit 3
fi

# grep -c prints path:count for every file (also 0); keep the non-zero ones as "count path"
R=$(grep -rciw --include='*.txt' -- "$WORD" "$DIR" | grep -v ':0$' |
    while IFS= read -r l; do echo "${l##*:} ${l%:*}"; done | sort -k1,1nr -k2)
L=0 F=0
if [ -n "$R" ]; then
  echo "$R"
  while read -r n _; do L=$((L + n)); F=$((F + 1)); done <<< "$R"
fi
echo "$L lines in $F files"
[ "$F" -gt 0 ] || exit 4

