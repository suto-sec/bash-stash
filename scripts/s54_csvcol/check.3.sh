# checker spec for s54 step 3 (see lib/engine.sh)
SCRIPT_NAME=csvcol.sh
setup() {
  mkfl people.csv "name,city,age" "ana,madrid,31" "luis,paris,25" "eva,madrid,31" "juan,roma,40" "mia,paris,25"
  mkfl one.csv "id" "7" "8"; : > empty.csv; echo x > locked.csv; chmod 000 locked.csv; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *csvcol.sh* ]]; }
ARGS=('people.csv 2' '-h people.csv 2' '-h one.csv 1' '-h empty.csv 1' '-h' '-x people.csv 2' '-h -x people.csv 2' '-h nothing.csv 1' '-h people.csv x' '')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; while [[ $1 == -* ]]; do shift; done; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "${@: -1}")"
  [[ $REF_CODE == 4 ]] && mentions "-x"
}
