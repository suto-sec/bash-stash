# checker spec for 0224 (see lib/engine.sh)
SCRIPT_NAME=mirror.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i p
  mkdir -p "src tree/.git/objects" otros
  for i in $(seq "$(randr 4 8)"); do
    p="src tree/$(pick "$(word)" "$(word) $(word)" "$(word)/$(word)")$i"
    mkdir -p "$p"
    touch "$p/$(word).txt"
  done
  touch "src tree/top.txt" fichero
  ln -s "src tree" enlace
}
ARGS=('"src tree" copia' '"src tree" "otros/mi copia"' '"src tree/" "$W/nuevo"' '"./src tree/.git" otros/git' 'noexiste copia' 'fichero copia' '"src tree" otros' '"src tree" "nada/copia"' '"src tree" "src tree/copia"' '"src tree" "./otros/../src tree/.git/../copia"' 'enlace "src tree/copia"' '"src tree"' '')
extra_check() {
  local a=(); mapfile -t a < <(cd "$W" && eval "set -- $CASE" && printf '%s\n' "$@")
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
