# checker spec for s11 step 2 (see lib/engine.sh)
SCRIPT_NAME=bigfiles.sh
setup() {
  mkdir -p data/sub empty; local i
  for i in 1 2 3 4 5 6; do bigfile "data/$(word)$i.dat" "$(randr 10 400)"; done
  bigfile "data/two words.dat" 250; bigfile "data/small.dat" 5; bigfile data/sub/inner.dat 900
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *bigfiles.sh* ]]; }
SORT_OUTPUT=1
ARGS=('data' 'empty' '' 'data empty' 'nothing' 'notadir.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
