#!/bin/bash
# informe.sh FILE...
if [ $# -eq 0 ]; then
  echo "usage: $(basename "$0") FILE..." >&2
  exit 1
fi

ok=0
skipped=0

revisar() {
  local file=$1
  if [ ! -f "$file" ] || [ ! -r "$file" ]; then
    echo "informe.sh: '$file' no accesible" >&2
    skipped=$((skipped + 1))
    return
  fi
  local f
  f=$(head -n 1 -- "$file")
  local l
  l=$(wc -l < "$file")
  echo "$file: primera linea = '$f' (lineas: $l)"
  ok=$((ok + 1))
}

for f in "$@"; do
  revisar "$f"
done

echo "procesados: $ok ok, $skipped saltados"
echo "ultimo arg: $f"

