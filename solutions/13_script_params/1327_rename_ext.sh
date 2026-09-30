#!/bin/bash
# chext.sh old new [directory] - change the extension of regular files

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: $(basename "$0") old new [directory]" >&2
  exit 1
fi
old=$1 new=$2 dir=${3:-.}

for e in "$old" "$new"; do
  if [[ ! $e =~ ^[A-Za-z0-9]+$ ]]; then
    echo "Error: invalid extension '$e'" >&2
    exit 2
  fi
done
if [ "$old" = "$new" ]; then
  echo "Error: both extensions are '$old'" >&2
  exit 3
fi
if [ ! -e "$dir" ]; then
  echo "Error: '$dir' does not exist" >&2
  exit 4
fi
if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory" >&2
  exit 5
fi

r=0 s=0
for f in "$dir"/*."$old"; do
  [ -f "$f" ] || continue          # also skips the literal pattern when nothing matches
  name=$(basename "$f")
  base=${name%."$old"}
  if [ -e "$dir/$base.$new" ]; then
    echo "skipped: $name ($base.$new exists)" >&2
    s=$((s + 1))
  else
    mv "$f" "$dir/$base.$new"
    echo "renamed: $name -> $base.$new"
    r=$((r + 1))
  fi
done
echo "Renamed $r, skipped $s"

