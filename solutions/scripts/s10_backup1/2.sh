#!/bin/bash
dest=$HOME/backup
if [[ ! -d $dest ]]; then
  mkdir -p "$dest"
  echo "Directory $dest created"
fi
cp -- "$1" "$dest/"
echo "Copied 1 files"
