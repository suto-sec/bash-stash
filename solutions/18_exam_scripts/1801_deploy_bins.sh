#!/bin/bash
# deploy_bins.sh [directory]
# Copies to $HOME/deploy/bin every regular executable *.sh / *.bin file under directory.

if [ $# -gt 1 ]; then
  echo "Error: too many arguments" >&2
  echo "Usage: $(basename "$0") [directory]" >&2
  exit 1
fi

DIR=${1:-.}
if [ ! -e "$DIR" ]; then
  echo "Error: '$DIR' does not exist" >&2
  exit 2
fi
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory" >&2
  exit 3
fi

DEST="$HOME/deploy/bin"
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST" || { echo "Error: cannot create $DEST" >&2; exit 4; }
  echo "Directory $DEST created"
fi

N=0
# process substitution (not a pipe) so that N is not lost in a subshell
while IFS= read -r -d '' f; do
  cp -f "$f" "$DEST/" && N=$((N + 1))
done < <(find "$DIR" -type f -perm /111 \( -name '*.sh' -o -name '*.bin' \) -print0)

echo "Copied $N files"

