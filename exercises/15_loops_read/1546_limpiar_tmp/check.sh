# checker spec for 1546 (see lib/engine.sh)
SCRIPT_NAME=limpiar_tmp.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "proj/sub uno" "proj/sub dos"
  local i d dirs=(proj "proj/sub uno" "proj/sub dos")
  for i in $(seq 3); do d=$(pick "${dirs[@]}"); bigfile "$d/$(word)$(pick '' ' ')$i.tmp" "$(randr 0 300)"; done
  for i in $(seq 2); do d=$(pick "${dirs[@]}"); bigfile "$d/$(word)$(pick '' ' ')$i.bak" "$(randr 0 300)"; done
  bigfile "proj/keep$(pick '' ' ').txt" "$(randr 0 300)"
  bigfile "proj/sub uno/keep2.bakup" "$(randr 0 300)"
  touch nota.txt
}
ARGS=('proj' '' 'proj extra' 'noexiste' 'nota.txt')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[0]}"
  must_use read
}
