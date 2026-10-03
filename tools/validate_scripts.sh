#!/bin/bash
# Self-test of the Scripts collection (run inside the container). For every step of every script:
#   1) its reference code passes the step's checker
#   2) a do-nothing script fails it
#   3) the previous step's reference code fails it (so every step adds something the checker can see)
# Explicit answer files are always passed, so nothing is written to .progress.
# usage: tools/validate_scripts.sh [script-id-prefix...]
source "$(dirname "$(readlink -f "$0")")/../lib/engine.sh"
lab_lock
tmp=$(mktemp -d); printf '#!/bin/bash\ntrue\n' > "$tmp/noop.sh"
bad=0 n=0 steps=0
pats=("$@"); [[ ${#pats[@]} -eq 0 ]] && pats=("")
for sdir in "$LAB"/scripts/s*/; do   # (engine functions use a global "d": never reuse that name here)
  sdir=${sdir%/}; id=$(ex_id "$sdir")
  ok=; for p in "${pats[@]}"; do [[ $id == "$p"* ]] && ok=1; done; [[ -n $ok ]] || continue
  n=$((n+1)); last=$(sc_last_step "$sdir"); problems=
  for ((k=1; k<=last; k++)); do
    steps=$((steps+1))
    sol="$LAB/solutions/scripts/$(basename "$sdir")/$k.sh"
    out=$(check_one "$id.$k" "$sol" 2>&1) || { problems+=" step$k:REF-FAILS"; echo "$out" | sed 's/^/    /' | head -25; }
    check_one "$id.$k" "$tmp/noop.sh" >/dev/null 2>&1 && problems+=" step$k:NOOP-PASSES"
    (( k > 1 )) && check_one "$id.$k" "$LAB/solutions/scripts/$(basename "$sdir")/$((k-1)).sh" >/dev/null 2>&1 && problems+=" step$k:PREVIOUS-STEP-PASSES"
  done
  if [[ -n $problems ]]; then echo "${R}PROBLEMS${N} $id:$problems"; bad=$((bad+1)); else echo "${G}ok${N} $id ($last steps)"; fi
done
rm -rf "$tmp"
echo "validated $n script(s), $steps step(s), with problems: $bad"
(( bad == 0 ))
