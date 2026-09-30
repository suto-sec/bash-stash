# checker spec for 1842 (see lib/engine.sh)
SCRIPT_NAME=fix_shebang.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p d/sub "d/con espacio"
  mkfl d/ok.sh '#!/bin/bash' 'echo hola'
  mkfl d/sub/nosheb.sh 'echo sin shebang' 'echo mas'
  mkfl "d/con espacio/otro.sh" '#!/bin/sh' 'echo distinto'
  : > d/vacio.sh
  mkfl d/notme.txt 'echo no aplica'
  touch archivo_no_dir
}
ARGS=('' 'd extra' 'd' 'noexiste' 'archivo_no_dir' 'd/sub')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *fix_shebang.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
