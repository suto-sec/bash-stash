# checker spec for s77 step 2 (see lib/engine.sh)
SCRIPT_NAME=onlyin.sh
setup() {
  mkdir -p d1 d2 same1 same2 "my one" "my two" empty
  touch d1/a d1/b d1/c d1/d "d1/two words" d1/.hid d1/shared.txt
  touch d2/b d2/c d2/e "d2/two words" d2/shared.txt d2/zeta
  touch same1/x same1/y same2/x same2/y
  touch "my one/p" "my one/q" "my two/q" "my two/r"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *onlyin.sh* ]]; }
ARGS=('d1 d2' 'd2 d1' 'same1 same2' '"my one" "my two"' 'empty d1' '' 'd1' 'd1 d2 same1' 'nothing d2' 'd1 nothing' 'notadir.txt d2' 'd1 notadir.txt' 'nothing notadir.txt' 'notadir.txt nothing')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == [23] ]]; then
    local bad; bad=$(cd "$W"; eval "set -- $CASE"; if [[ $REF_CODE == 2 ]]; then [[ -e $1 ]] && echo "$2" || echo "$1"; else [[ -d $1 ]] && echo "$2" || echo "$1"; fi)
    mentions "$bad"
  fi
}
