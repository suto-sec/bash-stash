#!/bin/bash
# genmv.sh DIR PREFIX - prints a script that renames the files of DIR to PREFIX_NNN.EXT
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") DIR PREFIX" >&2
  exit 1
fi
DIR=$1 PREFIX=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
[[ $PREFIX =~ ^[A-Za-z0-9_-]+$ ]] || { echo "Error: invalid prefix '$PREFIX'" >&2; exit 3; }

# quote: wrap in single quotes, each ' becomes '\''
quote() { printf "'%s'" "${1//\'/\'\\\'\'}"; }

N=0
OUTPUT=""
for f in "$DIR"/*; do
  [ -f "$f" ] || continue
  N=$((N + 1))
  name=${f##*/}
  new=$(printf '%s_%03d' "$PREFIX" "$N")
  [[ $name == *.* ]] && new="$new.${name##*.}"
  OUTPUT+="mv -- $(quote "$DIR/$name") $(quote "$DIR/$new")"$'\n'
done
if [ "$N" -eq 0 ]; then
  echo "Error: no regular files in '$DIR'" >&2
  exit 4
fi
echo '#!/bin/bash'
printf '%s' "$OUTPUT"
echo "# $N files"

