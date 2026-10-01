#!/bin/bash
while IFS= read -r -d '' f; do
  rel=${f#"$1"/}
  mkdir -p "$2/$(dirname "$rel")"
  cp -- "$f" "$2/$rel" 2>/dev/null && echo "copied $rel"
done < <(find "$1" -type f -print0)
exit 0
