#!/bin/bash
# informe_scripts.sh DIR
die() {
  local code=$1; shift
  echo "ERROR: $*" >&2
  exit "$code"
}
[ $# -eq 1 ] || die 1 "usage: $(basename "$0") DIR"
D=$1
[ -d "$D" ] || die 2 "'$D' no es un directorio"

analizar() {
  local f=$1 e s
  if [ -x "$f" ]; then e=exec; else e=noexec; fi
  if head -n 1 -- "$f" | grep -q '^#!'; then s=shebang; else s=sin-shebang; fi
  echo "$e $s"
}

n=0; ex=0; sh=0
while IFS= read -r -d '' f; do
  read -r e s <<< "$(analizar "$f")"
  echo "$f: $e, $s"
  n=$((n + 1))
  [ "$e" = exec ] && ex=$((ex + 1))
  [ "$s" = shebang ] && sh=$((sh + 1))
done < <(find "$D" -type f -name '*.sh' -print0 | sort -z)
echo "TOTAL: $n scripts, $ex ejecutables, $sh con shebang"

