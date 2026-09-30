# checker spec for 1832 (see lib/engine.sh)
SCRIPT_NAME=flatten_copy.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p src/a src/b/c "src/con espacio"
  echo one > src/a/dato.txt
  echo two > src/b/c/dato.txt
  echo three > "src/con espacio/otro archivo.txt"
  local i
  for i in $(seq 4); do echo "$(word)" > "src/$(pick . a 'b/c')/$(word)$i.txt"; done
  mkdir -p destino
  echo preexistente > "destino/otro archivo.txt"
  touch destino_es_archivo
  touch noesdir
}
ARGS=('' 'src' 'src destino extra' 'noexiste destino' 'noesdir destino' 'src destino_es_archivo' 'src destino' 'src "$W/dest_nuevo"' '"$W/src" destino')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *flatten_copy.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
