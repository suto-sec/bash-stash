#!/bin/bash
dest=$HOME/archives
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
name=$(basename "$1")
out=$dest/$name.tgz
tar czf "$out" -C "$(dirname "$1")" "$name"
echo "Created $out"
