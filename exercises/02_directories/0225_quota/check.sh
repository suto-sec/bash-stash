# checker spec for 0225 (see lib/engine.sh)
SCRIPT_NAME=cuota.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i d
  mkdir -p home2 vacio
  for i in $(seq "$(randr 3 6)"); do
    d="home2/$(pick "$(word)" "$(word) $(word)")$i"
    mkdir -p "$d/sub"
    bigfile "$d/data" $(( $(randr 1 50) * 8192 ))
    bigfile "$d/sub/more" $(( $(randr 0 30) * 8192 ))
  done
  mkdir home2/.cache; bigfile home2/.cache/big $((900 * 1024)); bigfile home2/suelto $((700 * 1024))
  touch fichero
}
ARGS=('home2 200' 'home2 200K' 'home2 1M' '"$W/home2" 64' 'vacio 10' 'home2 0' 'home2 5G' 'home2 2.5M' 'home2 M' 'home2 -5' 'fichero 10' 'noexiste 10' 'home2' '')
extra_check() {
  local a=(); mapfile -t a < <(cd "$W" && eval "set -- $CASE" && printf '%s\n' "$@")
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
