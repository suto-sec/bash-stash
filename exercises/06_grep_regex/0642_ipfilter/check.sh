# checker spec for 0642 (see lib/engine.sh)
SCRIPT_NAME=ipfilter.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('red.log "192.168.1."' 'red.log "192.168.10."' 'red.log "10.0.0."' 'red.log' 'red.log "192.168.1." extra' 'nofile.log "192.168.1."' 'red.log abc')
setup() {
  local n i
  n=$(randr 6 10)
  : > red.log
  for i in $(seq "$n"); do
    echo "conn from $(pick "192.168.1." "192.168.10." "10.0.0.")$(randr 1 254) $(pick ok drop timeout)" >> red.log
  done
  echo "conn from 192x168x1x77 raro" >> red.log
  echo "conn from 192.168.100.5 similar" >> red.log
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *ipfilter.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
