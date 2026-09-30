#!/bin/bash
# magic.sh FILE...: file type from the first bytes

if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") FILE..." >&2
  exit 1
fi

N=0 K=0 BAD=0
for f in "$@"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "Error: '$f' is not a readable regular file" >&2
    BAD=1
    continue
  fi
  m=$(od -An -tx1 -N4 "$f" | tr -d ' \n')
  case $m in
    89504e47) t=png ;;
    1f8b*)    t=gzip ;;
    7f454c46) t=elf ;;
    25504446) t=pdf ;;
    504b0304) t=zip ;;
    2321*)    t=script ;;
    *)        t=unknown ;;
  esac
  echo "$f: $t"
  N=$((N + 1))
  [ "$t" != unknown ] && K=$((K + 1))
done

echo "Identified $K of $N files"
[ $BAD -eq 1 ] && exit 2
exit 0

