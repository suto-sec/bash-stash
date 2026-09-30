#!/bin/bash
# generate.sh TEMPLATE LIST OUTDIR - one file per name, from a template

if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") TEMPLATE LIST OUTDIR" >&2
  exit 1
fi
TPL=$1 LIST=$2 OUT=$3
[ -f "$TPL" ] && [ -r "$TPL" ] || { echo "Error: cannot read template '$TPL'" >&2; exit 2; }
[ -f "$LIST" ] && [ -r "$LIST" ] || { echo "Error: cannot read list '$LIST'" >&2; exit 3; }
[ -e "$OUT" ] && [ ! -d "$OUT" ] && { echo "Error: '$OUT' is not a directory" >&2; exit 4; }

if [ ! -d "$OUT" ]; then
  mkdir -p "$OUT" && echo "Created $OUT"
fi

N=0 S=0 DONE=
while IFS= read -r name; do
  [ -z "$name" ] && continue
  if [[ ! $name =~ ^[A-Za-z0-9\ _-]+$ ]]; then
    echo "invalid name: $name" >&2; S=$((S + 1)); continue
  fi
  if grep -qxF -- "$name" <<< "$DONE"; then
    echo "duplicate: $name" >&2; S=$((S + 1)); continue
  fi
  DONE+="$name"$'\n'
  N=$((N + 1))
  sed "s/{{NAME}}/$name/g; s/{{N}}/$N/g" "$TPL" > "$OUT/$name.txt"
  echo "generated: $OUT/$name.txt"
done < "$LIST"

echo "Generated $N files, $S skipped"

