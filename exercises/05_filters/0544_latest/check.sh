# checker spec for 0544 (see lib/engine.sh)
SCRIPT_NAME=latest.sh
SEEDS=3
COMPARE="stdout exit errmsg"
ARGS=('app.log ERROR' 'app.log WARN 2' 'app.log INFO 100' '"old logs/app 1.log" ERROR 3' 'app.log DEBUG' 'app.log error' 'app.log' '' 'a b c d' 'nofile ERROR' '"old logs" ERROR' 'app.log ERROR 0' 'app.log ERROR x')
mklog() {
  local i n=$1 t=$(randr 0 50000) lv
  for ((i = 0; i < n; i++)); do
    t=$(( t + $(randr 1 900) ))
    lv=$(pick INFO INFO DEBUG WARN ERROR)
    printf '2026-09-%02d %02d:%02d:%02d %s %s\n' $(( 10 + t / 86400 )) $(( t / 3600 % 24 )) $(( t / 60 % 60 )) $(( t % 60 )) \
      "$lv" "$(pick "$(words 3)" "recovered from ERROR state" "WARN: $(word) is slow" "user $(word) INFO")"
  done
}
setup() {
  mklog "$(randr 15 35)" > app.log
  mkdir "old logs"
  mklog "$(randr 0 5)" > "old logs/app 1.log"
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *latest.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
