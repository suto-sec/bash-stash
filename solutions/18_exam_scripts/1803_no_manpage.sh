#!/bin/bash
[ $# -gt 2 ] && { echo "Usage: $(basename "$0") [bindir] [mandir]" >&2; exit 1; }
BIN=${1:-/bin}
MAN=${2:-/usr/share/man/man1}
for d in "$BIN" "$MAN"; do
  [ -d "$d" ] || { echo "Error: $d is not a directory" >&2; exit 1; }
done
N=0
for f in $(ls "$BIN" | sort); do
  if [ ! -e "$MAN/$f.1.gz" ]; then
    echo "$f"
    N=$((N + 1))
  fi
done
echo "Total: $N files without man page"

