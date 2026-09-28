#!/bin/bash
# Self-test of the checkers (run inside the container):
#   1) the reference solution must pass its own checker (also proves determinism)
#   2) a do-nothing answer must fail
# usage: tools/validate.sh [id-prefix...]
source "$(dirname "$(readlink -f "$0")")/../lib/engine.sh"
tmp=$(mktemp -d); printf '#!/bin/bash\ntrue\n' > "$tmp/noop.sh"; printf '1: x\n' > "$tmp/noop.txt"
bad=0 n=0
pats=("$@"); [[ ${#pats[@]} -eq 0 ]] && pats=("")
while read -r d; do
  id=$(ex_id "$d")
  ok=; for p in "${pats[@]}"; do [[ $id == "$p"* ]] && ok=1; done; [[ -n $ok ]] || continue
  n=$((n+1))
  load_spec "$d"
  if [[ $TYPE == quiz ]]; then
    sed 's/ *|.*//' "$(ex_sol "$d").txt" > "$tmp/first.txt"   # answer with the first accepted alternative
    sol=$tmp/first.txt noop=$tmp/noop.txt
  else sol="$(ex_sol "$d").sh" noop=$tmp/noop.sh; fi
  if ! o1=$(check_one "$id" "$sol" 2>&1); then echo "${R}REF FAILS${N} $id"; echo "$o1" | sed 's/^/    /'; bad=$((bad+1)); continue; fi
  if o2=$(check_one "$id" "$noop" 2>&1); then echo "${Y}NOOP PASSES${N} $id"; bad=$((bad+1)); continue; fi
  echo "${G}ok${N} $id"
done < <(all_ex)
rm -rf "$tmp"
echo "validated $n, problems: $bad"
(( bad == 0 ))
