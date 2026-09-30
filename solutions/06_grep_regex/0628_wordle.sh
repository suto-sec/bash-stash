#!/bin/bash
# wordle.sh DICT PATTERN [ABSENT]
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: $(basename "$0") DICT PATTERN [ABSENT]" >&2
  exit 1
fi
DICT=$1
PAT=$2
if [ ! -f "$DICT" ] || [ ! -r "$DICT" ]; then
  echo "Error: cannot read dictionary '$DICT'" >&2
  exit 2
fi
if ! grep -qxE '[a-z_]{5}' <<< "$PAT"; then
  echo "Error: invalid pattern '$PAT'" >&2
  exit 3
fi
if [ $# -eq 3 ] && ! grep -qxE '[a-z]+' <<< "$3"; then
  echo "Error: invalid absent letters '$3'" >&2
  exit 4
fi

RE=${PAT//_/.}     # _ = any letter
if [ $# -eq 3 ]; then
  R=$(grep -xE '[a-z]{5}' "$DICT" | grep -x "$RE" | grep -v "[$3]" | sort -u)
else
  R=$(grep -xE '[a-z]{5}' "$DICT" | grep -x "$RE" | sort -u)
fi
[ -n "$R" ] && echo "$R"
echo "$(grep -c . <<< "$R") candidates"

