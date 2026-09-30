#!/bin/bash
if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") ARCHIVE DEST MAXBYTES" >&2
  exit 1
fi
ARCH=$1
DEST=$2
MAXBYTES=$3
if [ ! -e "$ARCH" ] || ! tar -tzf "$ARCH" >/dev/null 2>&1; then
  echo "Error: '$ARCH' is not a valid tar.gz archive" >&2
  exit 2
fi
if ! [[ $MAXBYTES =~ ^[0-9]+$ ]]; then
  echo "Error: MAXBYTES must be a non-negative integer, got '$MAXBYTES'" >&2
  exit 3
fi

total=0
while read -r mode owner size date time name; do
  [[ $mode == d* ]] && continue
  total=$((total + size))
done < <(tar -tvzf "$ARCH")

if [ "$total" -gt "$MAXBYTES" ]; then
  echo "Refused: $total bytes exceed the $MAXBYTES bytes limit" >&2
  exit 4
fi

mkdir -p "$DEST"
tar -xzf "$ARCH" -C "$DEST"
n=$(tar -tzf "$ARCH" | wc -l)
echo "Extracted $n entries ($total bytes) into $DEST"
