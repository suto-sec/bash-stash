#!/bin/bash
# scriptcheck.sh [-f] DIR - find *.sh without shebang or without user execute permission
usage() { echo "Usage: $(basename "$0") [-f] DIR" >&2; exit 2; }

FIX=0
if [ "$1" = "-f" ]; then
  FIX=1
  shift
fi
[ $# -eq 1 ] || usage
case $1 in -*) usage ;; esac
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }

N=0
M=0
while IFS= read -r f; do
  N=$((N + 1))
  shebang=1
  exe=1
  [[ $(head -n 1 "$f") == '#!'* ]] || shebang=0
  [ -x "$f" ] || exe=0
  if [ $shebang -eq 0 ] && [ $exe -eq 0 ]; then echo "$f: no shebang, not executable"
  elif [ $shebang -eq 0 ]; then echo "$f: no shebang"
  elif [ $exe -eq 0 ]; then echo "$f: not executable"
  else continue
  fi
  M=$((M + 1))
  if [ $FIX -eq 1 ]; then
    [ $shebang -eq 0 ] && sed -i '1i #!/bin/bash' "$f"
    [ $exe -eq 0 ] && chmod u+x "$f"
  fi
done < <(find "$DIR" -type f -name '*.sh' | sort)

if [ $FIX -eq 1 ]; then
  echo "$N scripts checked, $M with problems, $M fixed"
else
  echo "$N scripts checked, $M with problems"
  [ $M -eq 0 ] || exit 1
fi

