# checker spec for 0833 (see lib/engine.sh)
SCRIPT_NAME=perm_histogram.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "arbol/a/b" arbol/c vacio
  local i f
  for i in $(seq 10); do
    f="arbol/$(pick . a "a/b" c)/$(pick "$(word)$i" "$(word) $i")"
    touch "$f"
    chmod "$(pick 644 600 755 640 700)" "$f"
  done
  local extra_dir; extra_dir=$(word)
  mkdir "arbol/${extra_dir}_dir"; chmod 755 "arbol/${extra_dir}_dir"
  ln -s "no_existe_$(word)" "arbol/$(word)_broken_link"
  touch fich
}
ARGS=('arbol' '"$W/arbol"' 'vacio' 'arbol extra' '' 'noexiste' 'fich')
extra_check() {
  case $REF_CODE in
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
