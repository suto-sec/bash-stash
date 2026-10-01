#!/bin/bash
# Generates exercises/ and solutions/ from tools/src/*.txt
# Source format:
#   @@topic 01_echo | Echo, quoting & variables
#   @@ex 0101 hello | Hello world
#   @@level 1
#   @@cmds echo
#   @@readme      (markdown statement until next @@)
#   @@check       (check.sh spec)
#   @@solution    (reference solution; .txt key if TYPE=quiz)
# Never overwrites an existing answer.sh / answer.txt.
set -euo pipefail
LAB=$(cd "$(dirname "$0")/.." && pwd)
cd "$LAB"
shopt -s nullglob
files=("${@:-tools/src/*.txt}")
[[ $# -eq 0 ]] && files=(tools/src/*.txt)

for src in "${files[@]}"; do
awk -v LAB="$LAB" '
function flush() {
  if (id == "") return
  dir = LAB "/exercises/" topic "/" id "_" slug
  sdir = LAB "/solutions/" topic
  system("mkdir -p \"" dir "\" \"" sdir "\"")
  quiz = (check ~ /TYPE=quiz/)
  stars = ""; for (i = 1; i <= 5; i++) stars = stars (i <= level ? "★" : "☆")
  f = dir "/README.md"
  printf "# %s · %s\n\n", id, title > f
  printf "**Topic:** %s · **Difficulty:** %s · **Commands:** %s\n\n", ttitle, stars, cmds > f
  printf "%s\n", readme > f
  close(f)
  f = dir "/check.sh"; printf "# checker spec for %s (see lib/engine.sh)\n%s\n", id, check > f; close(f)
  f = sdir "/" id "_" slug (quiz ? ".txt" : ".sh"); printf "%s\n", solution > f; close(f)
  if (!quiz) system("chmod +x \"" f "\"")
  print dir
  id = ""
}
function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
/^@@topic / { flush(); sub(/^@@topic /, ""); split($0, a, "|"); topic = trim(a[1]); ttitle = trim(a[2]); next }
/^@@ex /    { flush(); sub(/^@@ex /, ""); split($0, a, "|"); split(trim(a[1]), b, " "); id = b[1]; slug = b[2]; title = trim(a[2]);
              readme = check = solution = ""; level = 1; cmds = "-"; sec = ""; next }
/^@@level / { level = $2 + 0; next }
/^@@cmds /  { sub(/^@@cmds /, ""); cmds = $0; next }
/^@@(readme|check|solution)[ \t]*$/ { sec = substr($1, 3); next }
{
  if (sec == "readme")   readme   = readme   (readme   == "" ? "" : "\n") $0
  if (sec == "check")    check    = check    (check    == "" ? "" : "\n") $0
  if (sec == "solution") solution = solution (solution == "" ? "" : "\n") $0
}
END { flush() }
' "$src"
done | while read -r dir; do
  id=$(basename "$dir"); id=${id%%_*}
  if grep -q 'TYPE=quiz' "$dir/check.sh"; then
    if [[ ! -f $dir/answer.txt ]]; then
      key=$(ls "$LAB"/solutions/*/"$(basename "$dir")".txt)
      { echo "# $id — one answer per line after the colon"; grep -oE '^[0-9]+:' "$key" | sed 's/$/ /'; } > "$dir/answer.txt"
    fi
  elif [[ ! -f $dir/answer.sh ]]; then
    printf '#!/bin/bash\n# %s — write your answer below\n\n' "$id" > "$dir/answer.sh"
    chmod +x "$dir/answer.sh"
  fi
done

# index
{
  echo "# Exercise index"; echo
  for t in exercises/[0-9][0-9]_*/; do
    echo "## $(basename "$t")"; echo
    for d in "$t"[0-9]*_*/; do
      printf -- '- [%s](%s)\n' "$(head -1 "$d/README.md" | sed 's/^# //')" "${d#exercises/}README.md"
    done
    echo
  done
} > exercises/INDEX.md
echo "built $(ls -d exercises/*/[0-9]*_* | wc -l) exercises"
