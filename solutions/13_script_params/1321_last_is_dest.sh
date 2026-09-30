#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Usage: $(basename "$0") file... dir" >&2
  exit 1
fi
dest=${!#}
if [ ! -d "$dest" ]; then
  echo "Not a directory: $dest" >&2
  exit 2
fi
ok=0 skipped=0
for f in "${@:1:$#-1}"; do
  if [ -f "$f" ]; then
    cp "$f" "$dest/"
    echo "copied: $f"
    ok=$((ok + 1))
  else
    echo "skipped: $f" >&2
    skipped=$((skipped + 1))
  fi
done
echo "$ok copied, $skipped skipped"
[ $skipped -eq 0 ] || exit 3

