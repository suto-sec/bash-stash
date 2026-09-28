#!/bin/bash
usage() { echo "Usage: $(basename "$0") [-n] [-m] [directory]" >&2; exit 1; }
DRY=0; MOVE=0; DIR=
while [ $# -gt 0 ]; do
  case $1 in
    -n) DRY=1 ;;
    -m) MOVE=1 ;;
    -*) usage ;;
    *) [ -n "$DIR" ] && usage; DIR=$1 ;;
  esac
  shift
done
DIR=${DIR:-.}
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
if [ $MOVE -eq 1 ]; then VERB=move; PAST=moved; else VERB=copy; PAST=copied; fi
DEST="$HOME/deploy/bin"
if [ $DRY -eq 0 ] && [ ! -d "$DEST" ]; then mkdir -p "$DEST"; echo "Directory $DEST created"; fi
N=0
while IFS= read -r -d '' f; do
  if [ $DRY -eq 1 ]; then echo "would $VERB: $f"; N=$((N + 1))
  elif [ $MOVE -eq 1 ]; then mv -f "$f" "$DEST/" && N=$((N + 1))
  else cp -f "$f" "$DEST/" && N=$((N + 1))
  fi
done < <(find "$DIR" -type f -perm /111 \( -name '*.sh' -o -name '*.bin' \) -print0 | sort -z)
if [ $DRY -eq 1 ]; then echo "$N files would be $PAST"; else echo "${PAST^} $N files"; fi

