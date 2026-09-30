#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") ARCHIVE DEST" >&2
  exit 1
fi
ARCH=$1
DEST=$2
if [ ! -e "$ARCH" ]; then
  echo "Error: $ARCH does not exist" >&2
  exit 2
fi
if ! tar -tzf "$ARCH" >/dev/null 2>&1; then
  echo "Error: $ARCH is not a valid .tgz archive" >&2
  exit 3
fi

while IFS= read -r p; do
  case $p in
    /*|../*|*/../*)
      echo "Unsafe path in archive: $p" >&2
      exit 4
      ;;
  esac
done < <(tar -tzf "$ARCH" 2>/dev/null)

CREATED=0
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST"
  CREATED=1
fi
tar -xzf "$ARCH" -C "$DEST"
[ "$CREATED" -eq 1 ] && echo "Directory $DEST created"
N=$(tar -tzf "$ARCH" | wc -l)
echo "Extracted $N entries into $DEST"

