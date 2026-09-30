# checker spec for 1030 (see lib/engine.sh)
SCRIPT_NAME=colfreq.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i
  mkdir -p "data sets"
  echo "name,city,dept,job title" > people.csv
  for i in $(seq "$(randr 8 20)"); do
    echo "$(word) $i,$(pick Madrid Madrid Bilbao Sevilla 'San Sebastian' Vigo),$(pick sales it it hr ops),$(pick 'team lead' dev dev 'sys admin' intern)"
  done >> people.csv
  echo "id,department,city" > "data sets/staff.csv"
  for i in $(seq "$(randr 5 12)"); do echo "$i,$(pick sales it hr 'it support'),$(pick Leon Soria)"; done >> "data sets/staff.csv"
}
ARGS=('people.csv city' 'people.csv "job title" 2' '"$W/data sets/staff.csv" department 10' 'people.csv dept 1' 'people.csv salary' 'people.csv "job" 3' 'people.csv city 0' 'people.csv city x' 'nope.csv city' '"data sets" city' 'people.csv' 'a b c d')
extra_check() {
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
  true
}
