#!/bin/bash
while IFS= read -r -d '' f; do
  head -n 1 "$f" | grep -q '^#!' || echo "$f"
done < <(find "$1" -type f -name '*.sh' -print0)
exit 0
