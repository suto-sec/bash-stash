# checker spec for 1431 (see lib/engine.sh)
SCRIPT_NAME=pwcheck.sh
SEEDS=4
COMPARE="stdout exit errmsg"
input() {
  local i w
  for ((i = 0; i < $(randr 6 10); i++)); do
    w=$(word)
    pick "$w" "${w^}$(randr 1 99)" "${w^}$(randr 1 99)$(pick '!' '#' '*' '.' '_' '\' '?')" "$w$(randr 100 999)" \
         "$(pick '*' '-' '@')$w$(rand 9)" "${w^^}" "$w ${w^}1!" "" "${w:0:3}A1!" "$(randr 10000000 99999999)" "${w^}$(word)"
  done
}
ARGS=('' '12' '4' '6' '3' '65' 'x' '08' '8 9')
extra_check() {
  local tok
  if [[ $REF_CODE == 3 ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
