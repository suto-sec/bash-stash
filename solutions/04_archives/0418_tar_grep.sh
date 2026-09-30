#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") ARCHIVE PATTERN" >&2
  exit 1
fi
ARCH=$1
PAT=$2
if [ ! -e "$ARCH" ]; then
  echo "Error: $ARCH does not exist" >&2
  exit 2
fi
if ! tar -tzf "$ARCH" >/dev/null 2>&1; then
  echo "Error: $ARCH is not a valid .tgz archive" >&2
  exit 3
fi

N=0
while IFS= read -r m; do
  [[ $m == */ ]] && continue
  if tar -xOzf "$ARCH" "$m" 2>/dev/null | grep -qF -- "$PAT"; then
    echo "$m"
    N=$((N + 1))
  fi
done < <(tar -tzf "$ARCH" | sort)
echo "Matches: $N"

