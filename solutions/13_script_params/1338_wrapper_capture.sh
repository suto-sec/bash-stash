#!/bin/bash
# wrapper_capture.sh CMD [ARGS...]
if [ $# -eq 0 ]; then
  echo "usage: $(basename "$0") CMD [ARGS...]" >&2
  exit 1
fi
OUT=$("$@" 2>/dev/null)
CODE=$?
echo "salida:"
if [ -n "$OUT" ]; then
  while IFS= read -r line; do echo "> $line"; done <<< "$OUT"
fi
echo "exit: $CODE"
exit 0
