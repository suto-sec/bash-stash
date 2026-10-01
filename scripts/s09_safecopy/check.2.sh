# checker spec for s09 step 2 (see lib/engine.sh)
SCRIPT_NAME=safecopy.sh
setup() {
  echo "one" > a.txt; echo "two words" > "my file.txt"; echo "three" > b.txt
  mkdir out sub; echo "old" > out/b.txt; echo "x" > out/keep.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *safecopy.sh* ]]; }
ARGS=('a.txt copy.txt' '"my file.txt" out/new.txt' '' 'a.txt' 'a.txt b.txt c.txt' 'nothing.txt copy.txt' 'sub copy.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
