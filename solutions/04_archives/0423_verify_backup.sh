#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") DIR ARCHIVE" >&2
  exit 2
fi
DIR=$1
ARCH=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
if [ ! -e "$ARCH" ] || ! tar -tzf "$ARCH" >/dev/null 2>&1; then
  echo "Error: '$ARCH' is not a valid .tar.gz archive" >&2
  exit 4
fi

declare -A in_dir in_arch
while IFS= read -r rel; do in_dir[$rel]=1; done < <(cd "$DIR" && find . -type f | sed 's#^\./##')
while IFS= read -r rel; do
  [[ $rel == */ ]] && continue
  in_arch[$rel]=1
done < <(tar -tzf "$ARCH")

diffs=0
while IFS= read -r rel; do
  if [ -n "${in_dir[$rel]}" ] && [ -n "${in_arch[$rel]}" ]; then
    if ! tar -xOzf "$ARCH" "$rel" 2>/dev/null | cmp -s - "$DIR/$rel"; then
      echo "changed $rel"
      diffs=$((diffs + 1))
    fi
  elif [ -n "${in_dir[$rel]}" ]; then
    echo "missing $rel"
    diffs=$((diffs + 1))
  else
    echo "extra $rel"
    diffs=$((diffs + 1))
  fi
done < <({ printf '%s\n' "${!in_dir[@]}"; printf '%s\n' "${!in_arch[@]}"; } | sort -u)

echo "Differences: $diffs"
[ $diffs -eq 0 ]

