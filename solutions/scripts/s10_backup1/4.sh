#!/bin/bash
if (( $# == 0 )); then
  echo "Error: at least one file is needed" >&2
  echo "Usage: $0 file..." >&2
  exit 1
fi
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
