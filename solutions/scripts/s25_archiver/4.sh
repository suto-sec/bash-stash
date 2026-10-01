#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
dest=$HOME/archives
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
name=$(basename "$1")
out=$dest/$name.tgz
if [[ -e $out ]]; then echo "Error: $out already exists" >&2; exit 4; fi
tar czf "$out" -C "$(dirname "$1")" "$name"
echo "Created $out"
