# checker spec for s63 step 2 (see lib/engine.sh)
SCRIPT_NAME=mergecsv.sh
setup() {
  mkfl a.csv "id,name" "1,ana" "2,luis" "3,eva"; mkfl b.csv "id,name" "3,eva" "4,juan" "5,mia"
  mkfl other.csv "code,name" "9,x"; mkfl hdr.csv "id,name"; : > empty.csv; echo x > locked.csv; chmod 000 locked.csv; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *mergecsv.sh* ]]; }
ARGS=('a.csv b.csv' 'hdr.csv a.csv' '' 'a.csv' 'a.csv b.csv hdr.csv' 'nothing.csv a.csv' 'a.csv nothing.csv' 'adir a.csv' 'locked.csv a.csv' 'a.csv empty.csv' 'a.csv other.csv' 'other.csv b.csv')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == 2 ]]; then local a; a=$(eval "set -- $CASE"; [[ -s $W/$1 && -r $W/$1 && -f $W/$1 ]] && echo "$2" || echo "$1"); mentions "$a"; fi
}
