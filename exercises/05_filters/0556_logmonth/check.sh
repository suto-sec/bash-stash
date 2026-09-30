# checker spec for 0556 (see lib/engine.sh)
SCRIPT_NAME=logmonth.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('syslog.txt' 'syslog.txt 5' 'corto.txt 2' 'corto.txt 100' 'syslog.txt 3 x' 'nofile.txt' 'syslog.txt abc' 'syslog.txt 0')
setup() {
  local months=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
  local n i mo da h m s
  n=$(randr 8 14)
  : > syslog.txt
  for i in $(seq "$n"); do
    mo=$(pick "${months[@]}")
    da=$(printf '%02d' "$(randr 1 28)")
    h=$(printf '%02d' "$(randr 0 23)")
    m=$(printf '%02d' "$(randr 0 59)")
    s=$(printf '%02d' "$(randr 0 59)")
    echo "$mo $da $h:$m:$s host $(word) $(word)" >> syslog.txt
  done
  n=$(randr 4 8)
  : > corto.txt
  for i in $(seq "$n"); do
    mo=$(pick "${months[@]}")
    da=$(printf '%02d' "$(randr 1 28)")
    h=$(printf '%02d' "$(randr 0 23)")
    echo "$mo $da $h:00:00 host $(word)" >> corto.txt
  done
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *logmonth.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
