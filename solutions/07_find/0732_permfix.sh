#!/bin/bash
# permfix.sh DIR - directories and *.sh to 755, other regular files to 644
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") DIR" >&2
  exit 1
fi
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

N=0
M=0
while IFS= read -r p; do
  M=$((M + 1))
  if [ -d "$p" ] || [[ $p == *.sh ]]; then new=755; else new=644; fi
  old=$(stat -c %a "$p")
  if [ "$old" != "$new" ]; then
    chmod "$new" "$p"
    echo "$old -> $new $p"
    N=$((N + 1))
  fi
done < <(find "$DIR" \( -type d -o -type f \) | sort)
echo "Fixed $N of $M entries"

