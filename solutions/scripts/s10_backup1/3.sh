#!/bin/bash
dest=$HOME/backup
if [[ ! -d $dest ]]; then
  mkdir -p "$dest"
  echo "Directory $dest created"
fi
n=0
for f in "$@"; do
  if [[ -f $f ]] && cp -- "$f" "$dest/" 2>/dev/null; then
    n=$((n + 1))
  else
    echo "could not copy $f" >&2
  fi
done
echo "Copied $n files"
