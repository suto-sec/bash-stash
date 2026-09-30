#!/bin/bash
# pack.sh MANIFEST ARCHIVE - archive the regular files listed in MANIFEST

if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") MANIFEST ARCHIVE" >&2
  exit 1
fi
MAN=$1 ARC=$2
[ -f "$MAN" ] && [ -r "$MAN" ] || { echo "Error: cannot read manifest '$MAN'" >&2; exit 2; }
[[ $ARC == *.tar.gz ]] || { echo "Error: '$ARC' must end in .tar.gz" >&2; exit 3; }

FILES=() M=0 K=0
while IFS= read -r p; do
  if [ -f "$p" ]; then
    FILES+=("$p")
  elif [ -e "$p" ]; then
    echo "skipped: $p"; K=$((K + 1))
  else
    echo "missing: $p"; M=$((M + 1))
  fi
done < <(grep -v -e '^#' -e '^$' "$MAN")

if [ ${#FILES[@]} -eq 0 ]; then
  echo "Error: nothing to pack" >&2
  exit 4
fi
tar -czf "$ARC" -- "${FILES[@]}" || exit 5
echo "Packed ${#FILES[@]} files ($M missing, $K skipped)"

