#!/bin/bash
# fix_shebang.sh DIR
usage() { echo "Usage: $(basename "$0") DIR" >&2; }
[ $# -eq 1 ] || { usage; exit 1; }
DIR=$1
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
N=0; M=0
while IFS= read -r -d '' f; do
  M=$((M + 1))
  first=$(head -n 1 "$f")
  if [ "$first" != "#!/bin/bash" ]; then
    mode=$(stat -c '%a' "$f")
    tmp="$f.fixshebang.tmp"
    { echo "#!/bin/bash"; cat "$f"; } > "$tmp"
    chmod "$mode" "$tmp"
    mv "$tmp" "$f"
    echo "fixed: $f"
    N=$((N + 1))
  fi
done < <(find "$DIR" -type f -name '*.sh' -print0 | sort -z)
echo "Fixed $N of $M scripts"

