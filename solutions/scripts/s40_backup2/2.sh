#!/bin/bash
while IFS= read -r -d '' f; do
  rel=${f#"$1"/}
  if [[ -e $2/.last && ! $f -nt $2/.last ]]; then continue; fi
  mkdir -p "$2/$(dirname "$rel")"
  cp -- "$f" "$2/$rel" 2>/dev/null && echo "copied $rel"
done < <(find "$1" -type f -print0)
touch "$2/.last"
exit 0
