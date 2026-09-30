# checker spec for 0416 (see lib/engine.sh)
SCRIPT_NAME=unpack_safe.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p base
  local i n; n=$(randr 2 4)
  for i in $(seq "$n"); do randtext 2 > "base/$(word)$i.txt"; done
  local canary; canary="$(word).dat"
  randtext 2 > "$canary"
  tar -czf bueno.tgz -C base .
  ( cd base && tar -P -czf ../malo.tgz . "../$canary" ) 2>/dev/null
  echo "esto no es un tar" > roto.tgz
  mkdir "ya existe"
  randtext 1 > "ya existe/previo.txt"
}
ARGS=(
  ''
  'bueno.tgz'
  'bueno.tgz salida1 extra'
  'noexiste.tgz salida2'
  'roto.tgz salida3'
  'malo.tgz salida4'
  'bueno.tgz salida5'
  'bueno.tgz "ya existe"'
)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *unpack_safe.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4)
      local want; want=$(grep -oE '\.\./[^ ]+' <<< "$REF_ERR" | head -1)
      [[ -n $want ]] && mentions "$want"
      ;;
  esac
}
