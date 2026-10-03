#!/bin/bash
# Self-test of the script practice exams (run inside the container):
#   1) the reference solution must score 10/10 (also proves the fixtures are deterministic)
#   2) a do-nothing script must score at most 0.5
#   3) every tools/src/script-exams/partials/<id>.*.sh is graded and its "# expect: LOW..HIGH" range is asserted
# usage: tools/validate_script_exams.sh [id-prefix...]
source "$(dirname "$(readlink -f "$0")")/../lib/engine.sh"
lab_lock
tmp=$(mktemp -d); printf '#!/bin/bash\ntrue\n' > "$tmp/noop.sh"
bad=0 n=0
pats=("$@"); [[ ${#pats[@]} -eq 0 ]] && pats=("")
score() { grade_exam "$1" "$2" 2>&1 | awk -F'|' '$1 == "SCORE" { print $2 }'; }
for d in "$LAB"/script-exams/*/; do
  id=$(ex_id "${d%/}")
  ok=; for p in "${pats[@]}"; do [[ $id == "$p"* ]] && ok=1; done; [[ -n $ok ]] || continue
  n=$((n+1))
  sol="$(ex_sol "${d%/}").sh"
  s=$(score "$id" "$sol")
  if [[ $s != 10.00 ]]; then echo "${R}REF SCORES $s${N} $id"; grade_exam "$id" "$sol" 2>&1 | sed 's/^/    /' | head -40; bad=$((bad+1)); continue; fi
  s0=$(score "$id" "$tmp/noop.sh")
  if awk -v s="$s0" 'BEGIN { exit !(s > 0.5) }'; then echo "${Y}NOOP SCORES $s0${N} $id"; bad=$((bad+1)); continue; fi
  msg="${G}ok${N} $id  reference 10, do-nothing $s0"
  for part in "$LAB"/tools/src/script-exams/partials/"$id".*.sh; do
    [[ -f $part ]] || continue
    sp=$(score "$id" "$part")
    range=$(sed -n 's/^# expect: *//p' "$part" | head -1)
    lo=${range%%..*} hi=${range##*..}
    if awk -v s="$sp" -v lo="$lo" -v hi="$hi" 'BEGIN { exit !(s >= lo && s <= hi) }'; then msg+="; $(basename "$part" .sh | sed "s/^$id\.//") $sp"
    else msg+="; ${R}$(basename "$part") scored $sp, expected $range${N}"; bad=$((bad+1)); fi
  done
  echo "$msg"
done
rm -rf "$tmp"
echo "validated $n script exam(s), problems: $bad"
(( bad == 0 ))
