#!/bin/bash
dest=${2:-extracted}
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
tar xzf "$1" -C "$dest"
echo "Extracted $(tar tzf "$1" | wc -l) entries"
