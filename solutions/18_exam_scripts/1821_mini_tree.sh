#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
ND=0; NF=0
walk() { # dir indent
  local e name
  for e in "$1"/*; do
    [ -e "$e" ] || [ -L "$e" ] || continue
    name=$(basename "$e")
    if [ -L "$e" ]; then
      echo "$2$name -> $(readlink "$e")"; NF=$((NF + 1))
    elif [ -d "$e" ]; then
      echo "$2$name/"; ND=$((ND + 1))
      walk "$e" "$2  "
    else
      echo "$2$name"; NF=$((NF + 1))
    fi
  done
}
echo "$DIR"
walk "$DIR" "  "
echo "$ND directories, $NF files"

