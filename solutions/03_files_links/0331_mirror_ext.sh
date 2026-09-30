#!/bin/bash
n=0
while IFS= read -r f; do
  rel=${f#origen/}
  mkdir -p "destino/$(dirname "$rel")"
  cp "$f" "destino/$rel"
  echo "$rel"
  n=$((n + 1))
done < <(find origen -type f -name '*.log' | sort)
echo "Copied: $n"

