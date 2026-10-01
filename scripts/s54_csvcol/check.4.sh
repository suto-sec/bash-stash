# checker spec for s54 step 4 (see lib/engine.sh)
SCRIPT_NAME=csvcol.sh
setup() {
  mkfl people.csv "name,city,age" "ana,madrid,31" "luis,paris,25" "eva,madrid,31" "juan,roma,40" "mia,paris,25"
  mkfl one.csv "id" "7" "8"; : > empty.csv; echo x > locked.csv; chmod 000 locked.csv; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *csvcol.sh* ]]; }
ARGS=('people.csv 2' '-h people.csv 2' '-u people.csv 2' '-h -u people.csv 2' '-u -h people.csv 3' '-u one.csv 1' '-u empty.csv 1' '-u -x people.csv 2' '-u' '')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 4 ]] && mentions "-x"
}
