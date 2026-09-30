# checker spec for 1547 (see lib/engine.sh)
SCRIPT_NAME=clasifica_arbol.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "arbol2/sub uno" "arbol2/sub dos/deep"
  local i n=8 exts=(sh txt md jpg png dat '') e d
  local dirs=(arbol2 "arbol2/sub uno" "arbol2/sub dos" "arbol2/sub dos/deep")
  for i in $(seq "$n"); do
    e=$(pick "${exts[@]}")
    d=$(pick "${dirs[@]}")
    if [ -n "$e" ]; then bigfile "$d/$(word)$(pick '' ' ')$i.$e" "$(randr 0 400)"
    else bigfile "$d/$(word)$(pick '' ' ')$i" "$(randr 0 400)"
    fi
  done
  touch nota.txt
}
ARGS=('arbol2' '' 'arbol2 extra' 'noexiste' 'nota.txt')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  must_use case read
}
