# checker spec for 1532 (see lib/engine.sh)
SCRIPT_NAME=miembros.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local f i j m
  for f in grupos "mis grupos"; do
    echo "ana:x:1000:" > "$f"
    for i in $(seq "$(randr 5 8)"); do
      m=()
      for j in $(seq "$(randr 0 4)"); do m+=("$(pick ana anabel luis pedro eva_1 root juan)"); done
      m=$(printf '%s,' "${m[@]}"); m=${m%,}
      echo "$(word)$i:x:$((1000 + i)):$m"
    done >> "$f"
  done
}
ARGS=('grupos ana luis' '"mis grupos" anabel ana Eva pedro' 'grupos nadie eva_1 juan' '' 'grupos'
      'nada ana' 'grupos "ana luis" root')
extra_check() {
  [[ $REF_CODE == 2 ]] && mentions nada
  [[ $CASE == *Eva* ]] && [[ $ERR != *Eva* ]] && fail "the message should mention 'Eva'"
  must_use read
}
