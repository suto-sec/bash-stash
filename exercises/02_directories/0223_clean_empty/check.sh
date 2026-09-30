# checker spec for 0223 (see lib/engine.sh)
SCRIPT_NAME=cleanempty.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i p
  mkdir -p "datos/con espacio/vacío" datos/.oculto
  for i in $(seq 8); do
    p="datos/$(pick a b "con espacio")/$(word)$i"
    [[ $(rand 2) == 1 ]] && p="$p/$(word)"
    mkdir -p "$p"
    case $(rand 4) in 0) touch "$p/$(word).txt" ;; 1) touch "$p/.keep" ;; 2) ln -s /nowhere "$p/link" ;; esac
  done
  mkdir -p solo/vacio; touch fichero
}
ARGS=('datos' 'datos/' '"$W/datos/con espacio"' 'solo' 'noexiste' 'fichero' '' 'datos solo')
extra_check() {
  local a=(); mapfile -t a < <(cd "$W" && eval "set -- $CASE" && printf '%s\n' "$@")
  [[ $REF_CODE == [23] ]] && mentions "${a[0]}"
  true
}
