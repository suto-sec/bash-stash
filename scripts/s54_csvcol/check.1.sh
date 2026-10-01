# checker spec for s54 step 1 (see lib/engine.sh)
SCRIPT_NAME=csvcol.sh
setup() {
  mkfl people.csv "name,city,age" "ana,madrid,31" "luis,paris,25" "eva,madrid,31" "juan,roma,40" "mia,paris,25"
  mkfl one.csv "id" "7" "8"; : > empty.csv; echo x > locked.csv; chmod 000 locked.csv; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *csvcol.sh* ]]; }
ARGS=('people.csv 1' 'people.csv 2' 'people.csv 3' 'one.csv 1' 'empty.csv 1')
COMPARE="stdout exit"
