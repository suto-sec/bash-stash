#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 archive [dest]" >&2; exit 1; fi
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 2; }
case $1 in *.tgz|*.tar.gz) ;; *) echo "Error: $1 is not a .tgz or .tar.gz archive" >&2; exit 3 ;; esac
dest=${2:-extracted}
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
tar xzf "$1" -C "$dest"
echo "Extracted $(tar tzf "$1" | wc -l) entries"
