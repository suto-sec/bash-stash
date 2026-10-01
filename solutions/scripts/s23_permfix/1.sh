#!/bin/bash
while IFS= read -r -d '' f; do
  [[ $(stat -c %a "$f") == 755 ]] || echo "$f"
done < <(find "$1" -type f -name "*.sh" -print0)
exit 0
