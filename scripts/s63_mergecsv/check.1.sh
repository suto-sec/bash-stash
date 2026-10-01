# checker spec for s63 step 1 (see lib/engine.sh)
SCRIPT_NAME=mergecsv.sh
setup() {
  mkfl a.csv "id,name" "1,ana" "2,luis" "3,eva"; mkfl b.csv "id,name" "3,eva" "4,juan" "5,mia"
  mkfl other.csv "code,name" "9,x"; mkfl hdr.csv "id,name"; : > empty.csv; echo x > locked.csv; chmod 000 locked.csv; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *mergecsv.sh* ]]; }
ARGS=('a.csv b.csv' 'a.csv hdr.csv' 'hdr.csv b.csv' 'hdr.csv hdr.csv')
COMPARE="stdout exit"
