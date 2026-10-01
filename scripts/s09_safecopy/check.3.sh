# checker spec for s09 step 3 (see lib/engine.sh)
SCRIPT_NAME=safecopy.sh
setup() {
  echo "one" > a.txt; echo "two words" > "my file.txt"; echo "three" > b.txt
  mkdir out sub; echo "old" > out/b.txt; echo "x" > out/keep.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *safecopy.sh* ]]; }
ARGS=('a.txt copy.txt' 'a.txt out' 'a.txt out/' '"my file.txt" out' 'b.txt sub' '' 'nothing.txt out')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
