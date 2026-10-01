# checker spec for s24 step 3 (see lib/engine.sh)
SCRIPT_NAME=ownedby.sh
setup() {
  mkdir -p work/sub empty; local i
  for i in 1 2 3; do echo "$i" > "work/$(word)$i.txt"; done; echo 4 > work/sub/deep.txt; echo x > "work/two words.txt"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *ownedby.sh* ]]; }
SORT_OUTPUT=1
ARGS=('alumno work' 'root work' '' 'alumno' 'nobody_here work' 'alumno nothing' 'alumno notadir.txt' 'nobody_here nothing')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
