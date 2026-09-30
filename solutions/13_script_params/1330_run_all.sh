#!/bin/bash
# runall.sh [-e] file - run each line of file as a command and report exit codes

stop=0
if [ "$1" = "-e" ]; then
  stop=1
  shift
fi
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") [-e] file" >&2
  exit 2
fi
file=$1
if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  echo "Error: '$file' is not a readable regular file" >&2
  exit 3
fi

n=0 failed=0 num=0
while IFS= read -r line; do
  num=$((num + 1))
  [ -z "$line" ] && continue
  [[ $line == \#* ]] && continue
  bash -c "$line" > /dev/null 2>&1 < /dev/null
  rc=$?
  n=$((n + 1))
  if [ $rc -eq 0 ]; then
    echo "[ok] $line"
  else
    echo "[fail $rc] $line"
    failed=$((failed + 1))
    if [ $stop -eq 1 ]; then
      echo "Stopped at line $num"
      break
    fi
  fi
done < "$file"
echo "Commands: $n, failed: $failed"
[ $failed -eq 0 ] || exit 1
