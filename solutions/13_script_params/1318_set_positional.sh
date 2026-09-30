#!/bin/bash
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") text [separator]" >&2
  exit 1
fi
sep=${2-:}
if [ ${#sep} -ne 1 ]; then
  echo "Invalid separator" >&2
  exit 2
fi
text=$1
IFS=$sep
set -- $text
echo "$# fields"
i=1
for f in "$@"; do
  echo "$i: $f"
  i=$((i + 1))
done

