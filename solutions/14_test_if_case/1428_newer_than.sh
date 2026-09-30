#!/bin/bash
# newer_than.sh ref directory - classify files by age relative to ref

if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") ref directory" >&2
  exit 1
fi
ref=$1 dir=$2
if [ ! -e "$ref" ]; then
  echo "Error: '$ref' does not exist" >&2
  exit 2
fi
if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory" >&2
  exit 3
fi

newer=() older=() same=()
while IFS= read -r f; do
  [ "$f" -ef "$ref" ] && continue
  if [ "$f" -nt "$ref" ]; then newer+=("$f")
  elif [ "$f" -ot "$ref" ]; then older+=("$f")
  else same+=("$f")
  fi
done < <(find "$dir" -type f | sort)

echo "Newer than $ref:"
for f in "${newer[@]}"; do echo "  $f"; done
echo "Older than $ref:"
for f in "${older[@]}"; do echo "  $f"; done
echo "Same age as $ref:"
for f in "${same[@]}"; do echo "  $f"; done
echo "Summary: ${#newer[@]} newer, ${#older[@]} older, ${#same[@]} same"

