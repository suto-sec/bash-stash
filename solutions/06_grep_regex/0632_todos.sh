#!/bin/bash
# todos.sh DIR [TAG]
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") DIR [TODO|FIXME|XXX]" >&2
  exit 1
fi
DIR=$1
TAG=${2:-TODO}
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory" >&2
  exit 2
fi
case $TAG in
  TODO|FIXME|XXX) ;;
  *) echo "Error: invalid tag '$TAG'" >&2; exit 3 ;;
esac

R=$(grep -rnE --include='*.sh' --include='*.c' "(^|[^[:alnum:]_])$TAG:" "$DIR" |
    sort -t: -k1,1 -k2,2n | sed -E "s/^([^:]*:[0-9]+:).*$TAG:[[:space:]]*/\1 /")
[ -n "$R" ] && echo "$R"
N=$(grep -c . <<< "$R")
M=$(cut -d: -f1 <<< "$R" | sort -u | grep -c .)
echo "$N $TAG in $M files"

