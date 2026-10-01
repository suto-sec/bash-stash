# checker spec for s62 step 3 (see lib/engine.sh)
SCRIPT_NAME=splitfile.sh
setup() {
  local i
  for ((i = 1; i <= 10; i++)); do echo "line $i $(word)"; done > ten.txt
  for ((i = 1; i <= 3; i++)); do echo "short $i"; done > three.txt
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir; echo "old" > ten.txt.part2
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *splitfile.sh* ]]; }
ARGS=('three.txt 2' 'ten.txt 5' 'ten.txt 3' 'ten.txt 10' 'ten.txt 20' 'empty.txt 3' '' 'nothing.txt 2' 'three.txt x')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
  [[ $REF_CODE == 4 ]] && mentions "ten.txt.part2"
}
