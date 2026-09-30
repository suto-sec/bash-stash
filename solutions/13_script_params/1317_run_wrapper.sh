#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") command [args...]" >&2
  exit 64
fi
"$@" > /dev/null 2>&1
rc=$?
if [ $rc -eq 0 ]; then
  echo "OK: $*"
else
  echo "FAILED ($rc): $*"
fi
exit $rc

