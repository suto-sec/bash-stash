#!/bin/bash
# mkskel.sh SPECFILE DEST - creates the directories listed in SPECFILE under DEST
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") SPECFILE DEST" >&2
  exit 1
fi
SPEC=$1 DEST=$2
if [ ! -f "$SPEC" ] || [ ! -r "$SPEC" ]; then
  echo "Error: cannot read spec file '$SPEC'" >&2
  exit 2
fi
if [ -e "$DEST" ] && [ ! -d "$DEST" ]; then
  echo "Error: '$DEST' exists and is not a directory" >&2
  exit 3
fi
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST" && echo "Created $DEST"
fi

C=0 E=0 S=0 X=0
while IFS= read -r line; do
  [[ -z $line || $line == \#* ]] && continue
  if [[ $line == /* || $line == .. || $line == ../* || $line == */.. || $line == */../* ]]; then
    echo "skipped: $line" >&2
    S=$((S + 1))
  elif [ -d "$DEST/$line" ]; then
    echo "exists: $line"
    E=$((E + 1))
  elif mkdir -p "$DEST/$line" 2> /dev/null; then
    echo "created: $line"
    C=$((C + 1))
  else
    echo "error: $line" >&2
    X=$((X + 1))
  fi
done < "$SPEC"
echo "Created $C, existing $E, skipped $S, errors $X"
[ $((S + X)) -eq 0 ] || exit 4

