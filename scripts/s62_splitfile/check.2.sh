# checker spec for s62 step 2 (see lib/engine.sh)
SCRIPT_NAME=splitfile.sh
setup() {
  local i
  for ((i = 1; i <= 10; i++)); do echo "line $i $(word)"; done > ten.txt
  for ((i = 1; i <= 3; i++)); do echo "short $i"; done > three.txt
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir; echo "old" > ten.txt.part2
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *splitfile.sh* ]]; }
ARGS=('three.txt 2' 'empty.txt 3' '' 'three.txt' 'three.txt 1 2' 'nothing.txt 2' 'adir 2' 'locked.txt 2' 'three.txt 0' 'three.txt x' 'nothing.txt x')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
