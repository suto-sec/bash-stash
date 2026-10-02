#!/bin/bash
fix=
if [[ $1 == -f ]]; then fix=1; shift; fi
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [-f] [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
problems=0 scripts=0
while IFS= read -r -d '' f; do
  bad=0
  if ! head -n 1 "$f" | grep -q '^#!'; then
    bad=$((bad + 1))
    if [[ -n $fix ]]; then
      { echo '#!/bin/bash'; cat "$f"; } > "$f.tmp.$$" && cat "$f.tmp.$$" > "$f" && rm -f "$f.tmp.$$"
      echo "fixed $f: no shebang"
    else echo "$f: no shebang"; fi
  fi
  if [[ ! -x $f ]]; then
    bad=$((bad + 1))
    if [[ -n $fix ]]; then chmod a+x "$f"; echo "fixed $f: not executable"; else echo "$f: not executable"; fi
  fi
  problems=$((problems + bad))
  (( bad > 0 )) && scripts=$((scripts + 1))
done < <(find "$dir" -type f -name '*.sh' -print0)
if [[ -n $fix ]]; then echo "Fixed $problems problems in $scripts scripts"; exit 0; fi
echo "$problems problems in $scripts scripts"
(( problems == 0 )) || exit 4
