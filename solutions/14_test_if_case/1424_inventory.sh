#!/bin/bash
# inventory.sh [directory] - classify the entries of a directory

if [ $# -gt 1 ]; then
  echo "Error: too many arguments" >&2
  echo "Usage: $(basename "$0") [directory]" >&2
  exit 1
fi
dir=${1:-.}
if [ ! -e "$dir" ]; then
  echo "Error: '$dir' does not exist" >&2
  exit 2
fi
if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory" >&2
  exit 3
fi
if [ ! -r "$dir" ] || [ ! -x "$dir" ]; then
  echo "Error: cannot read '$dir'" >&2
  exit 4
fi

d=0 f=0 l=0 o=0
while IFS= read -r name; do
  p=$dir/$name
  if [ -L "$p" ] && [ ! -e "$p" ]; then tag="broken link"; l=$((l + 1))
  elif [ -L "$p" ]; then tag=link; l=$((l + 1))
  elif [ -d "$p" ]; then tag=dir; d=$((d + 1))
  elif [ -f "$p" ]; then
    f=$((f + 1))
    if [ -x "$p" ]; then tag=exec
    elif [ ! -s "$p" ]; then tag=empty
    else tag=file
    fi
  else tag=other; o=$((o + 1))
  fi
  echo "[$tag] $name"
done < <(ls -A "$dir")
echo "Total: $((d + f + l + o)) (dirs $d, files $f, links $l, other $o)"

