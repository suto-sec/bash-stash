# checker spec for s26 step 4 (see lib/engine.sh)
SCRIPT_NAME=rotate.sh
setup() {
  echo "log a" > a.log
  echo "log b" > b.log; echo "b1" > b.log.1
  echo "log c" > c.log; echo "c1" > c.log.1; echo "c2" > c.log.2; echo "c3" > c.log.3; echo "c4" > c.log.4
  echo "log d" > "my d.log"; echo "d1" > "my d.log.1"; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *rotate.sh* ]]; }
ARGS=('a.log' 'c.log 2' '"my d.log"' '' 'a.log 2 3' 'nothing.log' 'adir' 'a.log 0' 'a.log x' 'nothing.log x')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
