#!/bin/bash
# last_success.sh FILE...
if [ $# -eq 0 ]; then
  echo "usage: $(basename "$0") FILE..." >&2
  exit 1
fi
ok_pos=0
i=0
for f in "$@"; do
  i=$((i + 1))
  if cat -- "$f" > /dev/null 2>&1; then
    echo "OK: $f"
    ok_pos=$i
  else
    echo "FAIL: $f"
  fi
done
echo "ultimo_ok: $ok_pos de $#"

