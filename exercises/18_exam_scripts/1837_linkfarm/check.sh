# checker spec for 1837 (see lib/engine.sh)
SCRIPT_NAME=linkfarm.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p src/app src/db "src/con espacio"
  echo cfg1 > src/app/site.conf
  echo cfg2 > src/db/site.conf
  echo cfg3 > "src/con espacio/otro.conf"
  local i
  for i in $(seq 3); do echo "$(word)" > "src/$(pick app db)/$(word)$i.conf"; done
  mkdir -p destino
  touch destino/otro.conf
  touch destino_es_archivo
  touch noesdir
}
ARGS=('' 'src' 'src destino extra' 'noexiste destino' 'noesdir destino' 'src destino_es_archivo' 'src destino' 'src "$W/dest_nuevo"' '"$W/src" destino')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *linkfarm.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
