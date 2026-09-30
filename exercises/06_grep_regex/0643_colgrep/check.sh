# checker spec for 0643 (see lib/engine.sh)
SCRIPT_NAME=colgrep.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('usuarios.txt 3 "bash$"' 'usuarios.txt 2 "^1"' 'usuarios.txt 1 x' 'usuarios.txt 3' 'usuarios.txt' 'nofile.txt 3 x' 'usuarios.txt abc x' 'usuarios.txt 3 "["')
setup() {
  local n i
  n=$(randr 6 10)
  : > usuarios.txt
  for i in $(seq "$n"); do
    echo "$(word)$i:$(randr 1000 1999):$(pick /bin/bash /bin/sh /usr/sbin/nologin)" >> usuarios.txt
  done
  echo "root:0:/bin/bash" >> usuarios.txt
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *colgrep.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$3")" ;;
  esac
}
