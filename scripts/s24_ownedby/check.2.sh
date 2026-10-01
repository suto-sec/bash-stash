# checker spec for s24 step 2 (see lib/engine.sh)
SCRIPT_NAME=ownedby.sh
setup() {
  mkdir -p work/sub empty; local i
  for i in 1 2 3; do echo "$i" > "work/$(word)$i.txt"; done; echo 4 > work/sub/deep.txt; echo x > "work/two words.txt"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *ownedby.sh* ]]; }
SORT_OUTPUT=1
ARGS=('alumno work' 'root work' '' 'alumno' 'alumno work empty' 'alumno nothing' 'alumno notadir.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
