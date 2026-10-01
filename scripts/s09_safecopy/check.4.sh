# checker spec for s09 step 4 (see lib/engine.sh)
SCRIPT_NAME=safecopy.sh
setup() {
  echo "one" > a.txt; echo "two words" > "my file.txt"; echo "three" > b.txt
  mkdir out sub; echo "old" > out/b.txt; echo "x" > out/keep.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *safecopy.sh* ]]; }
ARGS=('a.txt copy.txt' 'a.txt out' 'b.txt out' 'b.txt out/b.txt' 'a.txt a.txt' 'b.txt out/' '' 'nothing.txt out' 'a.txt out/keep.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; d=$2; [[ -d $d ]] && d=${d%/}/$(basename "$1"); echo "$d")"
}
