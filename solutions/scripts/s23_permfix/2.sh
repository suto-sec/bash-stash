#!/bin/bash
while IFS= read -r -d '' f; do
  if [[ $(stat -c %a "$f") != 755 ]]; then chmod 755 "$f"; echo "fixed $f"; fi
done < <(find "$1" -type f -name "*.sh" -print0)
exit 0
