#!/bin/bash
[ $# -ge 1 ] && [ $# -le 2 ] || { echo "Usage: $(basename "$0") SRC [DEST]" >&2; exit 1; }
SRC=$1
DEST=${2:-$HOME/backups}
[ -d "$SRC" ] || { echo "Error: $SRC is not a directory" >&2; exit 2; }
N=$(find "$SRC" -type f -name '*.conf' | wc -l)
[ "$N" -gt 0 ] || { echo "Error: no .conf files in $SRC" >&2; exit 3; }
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST" || exit 4
  echo "Created $DEST"
fi
OUT=$(cd "$DEST" && pwd)/conf_backup.tgz
(cd "$SRC" && find . -type f -name '*.conf' -print0 | tar -czf "$OUT" --null -T -)
echo "Archived $N files into $DEST/conf_backup.tgz"

