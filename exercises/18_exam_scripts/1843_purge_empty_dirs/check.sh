# checker spec for 1843 (see lib/engine.sh)
SCRIPT_NAME=purge_empty_dirs.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p d/vacio1/vacio2/vacio3 d/vacio4 d/lleno
  touch d/lleno/archivo.txt
  mkdir -p "d/con espacio/subvacio"
  mkdir -p d/mixto/vacioA d/mixto/vacioB
  touch d/mixto/no_borrar.txt
  touch archivo_no_dir
}
ARGS=('' 'd extra' 'noexiste' 'archivo_no_dir' 'd/lleno' 'd/mixto' 'd')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *purge_empty_dirs.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
