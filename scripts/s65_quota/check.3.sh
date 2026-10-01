# checker spec for s65 step 3 (see lib/engine.sh)
SCRIPT_NAME=quota.sh
setup() {
  mkdir -p proj/sub empty; bigfile proj/a.dat 1000; bigfile proj/sub/b.dat 2500; bigfile "proj/two words.dat" 500; bigfile proj/sub/c.dat 0
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *quota.sh* ]]; }
ARGS=('proj 5000' 'empty 0' '' 'proj' 'proj 1 2' 'nothing 5' 'notadir.txt 5' 'proj x' 'proj -1' 'nothing x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
