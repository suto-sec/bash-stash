#!/bin/bash
find docs -type f -name '*.txt' -print0 | xargs -0 wc -l | grep -v ' total$' |
  sed 's/^ *//' | sort -k1,1nr -k2 | head -n 3
echo "Total: $(find docs -type f -name '*.txt' -print0 | xargs -0 cat | wc -l) lines"

