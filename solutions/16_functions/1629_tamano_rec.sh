#!/bin/bash
# tamano_rec.sh DIR
[ $# -eq 1 ] || { echo "usage: $(basename "$0") DIR" >&2; exit 1; }
[ -d "$1" ] || { echo "error: '$1' no es un directorio" >&2; exit 2; }

tamano() {
  local dir=$1 bytes=0 files=0 dirs=0
  while IFS= read -r -d '' e; do
    if [ -L "$e" ]; then
      continue
    elif [ -d "$e" ]; then
      local b f d
      read -r b f d <<< "$(tamano "$e")"
      bytes=$((bytes + b)); files=$((files + f)); dirs=$((dirs + d + 1))
    elif [ -f "$e" ]; then
      bytes=$((bytes + $(stat -c %s "$e")))
      files=$((files + 1))
    fi
  done < <(find "$dir" -mindepth 1 -maxdepth 1 -print0)
  echo "$bytes $files $dirs"
}

read -r B F D <<< "$(tamano "$1")"
echo "TOTAL: $1 = $B bytes ($F files, $D dirs)"
