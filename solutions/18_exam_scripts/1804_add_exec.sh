#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
N=0
while IFS= read -r -d '' f; do
  echo "$f"
  chmod +x "$f" && N=$((N + 1))
done < <(find "$DIR" -type f -name '*.sh' ! -perm -111 -print0 | sort -z)
echo "Updated $N files"

